tool
extends Shader

signal error(line, error_msg)

export var defines := {} setget set_defines

var raw_code := "" setget set_code, get_raw_code

func _init():
	if not self.is_connected("error", self, "_on_error"):
		if connect("error", self, "_on_error"):
			printerr("failed to connect own signal!")
	
func _on_error(line, error):
	printerr(":", line, " - Extended Shader Preprocessor: ", error)

func set_defines(value : Dictionary) -> void:
	if value:
		defines = value
	else:
		defines = {}
	update_code()

func set_code(value : String) -> void:
	raw_code = value
	update_code()

func get_raw_code() -> String:
	return raw_code

func update_code() -> void:

	var result = expand_includes(raw_code)
	print("parsed include statements recursively, produced: \n", result)
	result = process_directives(result)
	
	#trim unneeded trailing newlines
	result.strip_edges()
	result += "\n"
	# disabled because it's unnecessary and makes the raw view less pleasant
	# result = remove_comments(result)
	.set_code(result)
	
func get_include_in_line(line: int) -> Dictionary:
	var lines : PoolStringArray = raw_code.split("\n")
	var result = Dictionary()
	var path := get_include_for_line(lines[line])
	if path != "":
		if not path.get_extension():
			path = path + ".extshader"
		#if path
		var start_idx = (lines[line] as String).find("include")
		if not start_idx:
			return result
		result["path"] = path
		result["start_idx"] = start_idx
		result["end_idx"] = start_idx + "include".length()
	return result

var base_include := create_reg_exp("^[\t ]*#[\t ]*include[\t ]")
var include := create_reg_exp("^[\t ]*#[\t ]*include[\t ]+\"(?<filepath>[ \\d\\w\\-:/.\\(\\)]+)\"")
var builtin_include := create_reg_exp("^[\t ]*#[\t ]*include[\t ]+<\"(?<filepath>[ \\d\\w\\-:/.\\(\\)]+)\">")

func get_include_for_line(line: String) -> String:
	var Match := include.search(line)
	if Match:
		var path := Match.get_string("filepath")
		return path
	else:
		Match = builtin_include.search(line)
		if Match:
			var path := Match.get_string("filepath")
			return path
	return ""

func expand_includes(string : String, override_line_num: int = -1) -> String:
	
	var lines : PoolStringArray = string.split("\n")
	var line_num := 0
	while line_num < lines.size():
		var line := lines[line_num]
		var Match := include.search(line)
		var path: String
		if Match:
			path = Match.get_string("filepath")
		else:
			Match = builtin_include.search(line)
			if Match:
				path = Match.get_string("filepath")
				path = "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/" + path
		if Match:
			if not path.get_extension():
				path = path + ".extshader"
			lines.remove(line_num)
			if ResourceLoader.exists(path):
				var resource := load(path)
				
				var sub_code : String
#				print(path.get_extension())
				if resource is Shader:
					print("Resource class is ", resource.get_script().get_class())
					# get the raw code instead of the preprocessed code
					# so that things like #define will work cross-file
					# (allowing constructs like `#ifndef WAS_LOADED`)
					if resource.has_method("get_raw_code"):
						sub_code = resource.get_raw_code()
					else:
						sub_code = resource.code
				else:
					emit_signal("error", 
						line_num + 1 if override_line_num == -1 else override_line_num, 
						"You can only include shader files.")
				
				sub_code = expand_includes(sub_code, line_num + 1).trim_suffix("\n")
				lines.insert(line_num, "/**** END OF INCLUDE FROM  \"" + path + "\" ****/")
				lines.insert(line_num, sub_code)
				lines.insert(line_num, "/**** INCLUDED FROM  \"" + path + "\" ****/")
				line_num += 1
			else:
				emit_signal("error", 
					line_num + 1 if override_line_num == -1 else override_line_num, 
					"Invalid include path")
			continue
		elif base_include.search(line):
			emit_signal("error", 
				line_num + 1 if override_line_num == -1 else override_line_num, 
				"Invalid include statement")
		line_num += 1
	
	string = ""
	for line in lines:
		string += line + "\n"
	return string.strip_edges()

func remove_comments(string : String) -> String:
	var comment := create_reg_exp("(//[^\\n]*\\n?)|(/\\*[\\S\\s]*\\*/)")
	return comment.sub(string, "", true)

func process_directives(string : String, override_line_num: int = -1) -> String:
	var define_mac := create_reg_exp("^[\t ]*#[\t ]*define[\t ]+(?<name>\\w[\\d\\w]*)[\t ]*(?<value>[^\\\\]+)?")
	var define_func := create_reg_exp("\\(([\t ]*[\\w]+[\t ]*,*[\t ]*)+\\)")
	var undefine := create_reg_exp("^[\t ]*#[\t ]*undef[\t ]+(?<name>\\w[\\d\\w]*)")
	
	var ifdef := create_reg_exp("^[\t ]*#[\t ]*if(?<define>(?<negated>n)?def)?[\t ]+(?<expression>[^\\\\]+)")
	var elifd := create_reg_exp("^[\t ]*#[\t ]*elif[\t ]+(?<condition>[^\\\\]+)")
	var else_endif := create_reg_exp("^[\t ]*#[\t ]*((?<else>else)|(endif))")
	
	var defines := self.defines.duplicate()
	var if_stack := []
	
	var lines : PoolStringArray = string.split("\n")
	var line_num := 0
	while line_num < lines.size():
		var line := lines[line_num]
		
		var Match := define_mac.search(line)
		if Match:
			var name := Match.get_string("name")
			var value = Match.get_string("value")
			
			if value:
				var params = define_func.search(value)
				params = params.get_string() if params else null
				
				if params:
					var Func = value.replace(params, "")
					Func = replace_defines(Func, defines)
					params = params.replace(" ", "").replace("(", "").replace(")", "")
					params = params.trim_suffix(",")
					params = params.split(",")
					
					value = {"params":params, "func":Func}
			
			defines[name] = value if value else 1
			lines.remove(line_num)
			continue
		
		Match = undefine.search(line)
		if Match:
			var name := Match.get_string("name")
			
			if defines.has(name):
				defines.erase(name)
			lines.remove(line_num)
			
			continue
		
		Match = ifdef.search(line)
		if Match:
			var negated := Match.get_start("negated") != -1
			
			var state : bool
			if Match.get_string("define"):
				var name := Match.get_string("expression")
				state = defines.has(name)
			else:
				var condition = Match.get_string("expression")
				state = evaluate_condition(condition, defines)
			
			state = ((not state) if negated else state)
			if_stack.push_front({"line":line_num, "state":state})
			lines.remove(line_num)
			continue
		
		Match = else_endif.search(line)
		if Match:
			var stack = if_stack.pop_front()
			if not stack:
				emit_signal("error", line_num + 1, "Uneven amount of ifs and endifs!")
				break
			
			lines.remove(line_num)
			
			if not stack.state:
				for l in range(stack.line, line_num):
					lines.remove(stack.line)
					line_num -= 1
			
			var is_else = Match.get_start("else") != -1
			if is_else:
				if_stack.push_front({"line":line_num, "state":not stack.state})
			
			continue
		
		Match = elifd.search(line)
		if Match:
			var stack = if_stack.pop_front()
			if not stack:
				emit_signal("error", line_num, "Uneven amount of ifs and endifs!")
				break
			
			lines.remove(line_num)
			
			if not stack.state:
				for l in range(stack.line, line_num):
					lines.remove(stack.line)
					line_num -= 1
			
			var condition = Match.get_string("condition")
			var state = evaluate_condition(condition, defines)
			if_stack.push_front({"line":line_num, "state":state})
			
			continue
		
		if not Match:
			lines[line_num] = replace_defines(line, defines)
			line_num += 1
	
#	if not defines.empty():
#		print(defines)
	
	string = ""
	for line in lines:
		string += line + "\n"
	return string.strip_edges()

func replace_defines(line : String, defines : Dictionary) -> String:
	for define in defines:
		var define_var := create_reg_exp("[^\\d\\w]"+define+"[^\\d\\w]")
		var define_func := create_reg_exp("[^\\d\\w]"+define+"[ ]*\\((?<vars>[^\\(\\)\\\\]+)\\)")
		
		if typeof(defines[define]) == TYPE_DICTIONARY: # If the macro is a function
			var def_match := define_func.search(line)
			while def_match:
				var params : Array = defines[define]["params"]
				var function : String = defines[define]["func"]
				
				var vars_string := def_match.get_string("vars")
				var vars := vars_string.split(",")
				
				var params_dict = {}
				for i in params.size():
					params_dict[params[i]] = vars[i]
				
				line.erase(def_match.get_start() + 1, def_match.get_end() - def_match.get_start() - 1)
				line = line.insert(def_match.get_start() + 1, replace_defines(function, params_dict))
				
				def_match = define_var.search(line)
		else:
			var def_match := define_var.search(line)
			while def_match:
				line.erase(def_match.get_start() + 1, def_match.get_end() - def_match.get_start() - 2)
				line = line.insert(def_match.get_start() + 1, defines[define] if defines[define] else 1)
				def_match = define_var.search(line)
	
	return line

func evaluate_condition(condition : String, defines : Dictionary) -> bool:
	var defined := create_reg_exp("defined[ ]*\\([ ]*(?<macro>\\w[\\w\\d]+)[ ]*\\)")
	
	var matches := defined.search_all(condition)
	for i in range(matches.size() - 1, -1, -1):
		var regexmatch : RegExMatch = matches[i]
		var macro := regexmatch.get_string("macro")
		
		var index := regexmatch.get_start()
		var length := regexmatch.get_end() - index
		
		condition.erase(index, length)
		condition = condition.insert(index, "true" if defines.has(macro) else "false")
	
	condition = replace_defines(condition, defines)
	
	var expression := Expression.new()
	var error := expression.parse(condition)
	if error:
		emit_signal("error", -1, "A condition failed to be parsed: " + condition + " : " + str(error))
		return false
	
	var boolean : bool = expression.execute()
	
	return false if boolean == null else boolean

func create_reg_exp(string : String) -> RegEx:
	var reg_exp := RegEx.new()
	reg_exp.compile(string)
	
	if not reg_exp.is_valid():
		printerr("'" + string + "' is not a valid regular expression!")
	
	return reg_exp

