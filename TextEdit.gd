extends "res://addons/sisilicon.shaders.extended-shader/ExtShaderTextEditor.gd"

var BUILTIN_FUNCTIONS = [
	{"return": "vec_type", "name": "radians", "arguments": [{"type": "vec_type", "name": "degrees"}], "priority": 0},
	{"return": "vec_type", "name": "degrees", "arguments": [{"type": "vec_type", "name": "radians"}], "priority": 0},
	{"return": "vec_type", "name": "sin", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "cos", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "tan", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "asin", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "acos", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "atan", "arguments": [{"type": "vec_type", "name": "y_over_x"}], "priority": 0},
	{"return": "vec_type", "name": "atan", "arguments": [
		{"type": "vec_type", "name": "y"}, 
		{"type": "vec_type", "name": "x"}
	], "priority": 0},
	{"return": "vec_type", "name": "sinh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "cosh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "tanh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "asinh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "acosh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "atanh", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "pow", "arguments": [
		{"type": "vec_type", "name": "x"}, 
		{"type": "vec_type", "name": "y"}
	], "priority": 0},
	{"return": "vec_type", "name": "exp", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "exp2", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "log", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "log2", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "sqrt", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "inversesqrt", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "abs", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "ivec_type", "name": "abs", "arguments": [{"type": "ivec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "sign", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "ivec_type", "name": "sign", "arguments": [{"type": "ivec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "floor", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "round", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "roundEven", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "trunc", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "ceil", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "fract", "arguments": [{"type": "vec_type", "name": "x"}], "priority": 0},
	{"return": "vec_type", "name": "mod", "arguments": [
		{"type": "vec_type", "name": "x"}, 
		{"type": "vec_type", "name": "y"}
	], "priority": 0},
	{"return": "vec_type", "name": "mod", "arguments": [
		{"type": "vec_type", "name": "x"}, 
		{"type": "float", "name": "y"}
	], "priority": 0},
	{"return": "vec_type", "name": "modf", "arguments": [
		{"type": "vec_type", "name": "x"}, 
		{"type": "out vec_type", "name": "i"}
	], "priority": 0},
	{"return": "vec_type", "name": "min", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}
	], "priority": 0},
	{"return": "vec_type", "name": "max", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}
	], "priority": 0},
	{"return": "vec_type", "name": "clamp", "arguments": [
		{"type": "vec_type", "name": "x"}, 
		{"type": "vec_type", "name": "min"}, 
		{"type": "vec_type", "name": "max"}
	], "priority": 0},
	{"return": "float", "name": "mix", "arguments": [
		{"type": "float", "name": "a"}, 
		{"type": "float", "name": "b"}, 
		{"type": "float", "name": "c"}
	], "priority": 0},
	{"return": "vec_type", "name": "mix", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
		{"type": "float", "name": "c"}
	], "priority": 0},
	{"return": "vec_type", "name": "mix", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
		{"type": "vec_type", "name": "c"}
	], "priority": 0},
	{"return": "vec_type", "name": "mix", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
		{"type": "bvec_type", "name": "c"}
	], "priority": 0},
	{"return": "vec_type", "name": "step", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}
	], "priority": 0},
	{"return": "vec_type", "name": "step", "arguments": [
		{"type": "float", "name": "a"}, 
		{"type": "vec_type", "name": "b"}
	], "priority": 0},
	{"return": "vec_type", "name": "smoothstep", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
		{"type": "vec_type", "name": "c"}
	], "priority": 0},
	{"return": "vec_type", "name": "smoothstep", "arguments": [
		{"type": "float", "name": "a"}, 
		{"type": "float", "name": "b"}, 
		{"type": "vec_type", "name": "c"}
	], "priority": 0},
	{"return": "bvec_type", "name": "isnan", "arguments": [
		{"type": "vec_type", "name": "x"} 
	], "priority": 0},
	{"return": "bvec_type", "name": "isinf", "arguments": [
		{"type": "vec_type", "name": "x"} 
	], "priority": 0},
	{"return": "ivec_type", "name": "floatBitsToInt", "arguments": [
		{"type": "vec_type", "name": "x"} 
	], "priority": 0},
	{"return": "uvec_type", "name": "floatBitsToUint", "arguments": [
		{"type": "vec_type", "name": "x"} 
	], "priority": 0},
	{"return": "vec_type", "name": "intBitsToFloat", "arguments": [
		{"type": "ivec_type", "name": "x"} 
	], "priority": 0},
	{"return": "vec_type", "name": "uintBitsToFloat", "arguments": [
		{"type": "uvec_type", "name": "x"} 
	], "priority": 0},
	{"return": "float", "name": "length", "arguments": [
		{"type": "vec_type", "name": "x"} 
	], "priority": 0},
	{"return": "float", "name": "distance", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
	], "priority": 0},
	{"return": "float", "name": "dot", "arguments": [
		{"type": "vec_type", "name": "a"}, 
		{"type": "vec_type", "name": "b"}, 
	], "priority": 0},
	{"return": "vec3", "name": "cross", "arguments": [
		{"type": "vec3", "name": "a"}, 
		{"type": "vec3", "name": "b"}, 
	], "priority": 0},
	{"return": "vec_type", "name": "normalize", "arguments": [
		{"type": "vec_type", "name": "x"}, 
	], "priority": 0},
	{"return": "vec3", "name": "reflect", "arguments": [
		{"type": "vec3", "name": "I"}, 
		{"type": "vec3", "name": "N"}, 
	], "priority": 0},
	{"return": "vec3", "name": "refract", "arguments": [
		{"type": "vec3", "name": "I"}, 
		{"type": "vec3", "name": "N"}, 
		{"type": "float", "name": "eta"}, 
	], "priority": 0},
	{"return": "vec_type", "name": "faceforward", "arguments": [
		{"type": "vec_type", "name": "N"}, 
		{"type": "vec_type", "name": "I"}, 
		{"type": "vec_type", "name": "Nref"}, 
	], "priority": 0},
	{"return": "mat_type", "name": "matrixCompMult", "arguments": [
		{"type": "mat_type", "name": "x"}, 
		{"type": "mat_type", "name": "y"},
	], "priority": 0},
	{"return": "mat_type", "name": "outerProduct", "arguments": [
		{"type": "vec_type", "name": "column"}, 
		{"type": "vec_type", "name": "row"},
	], "priority": 0},
	{"return": "mat_type", "name": "transpose", "arguments": [
		{"type": "mat_type", "name": "m"},
	], "priority": 0},
	{"return": "float", "name": "determinant", "arguments": [
		{"type": "mat_type", "name": "m"},
	], "priority": 0},
	{"return": "mat_type", "name": "inverse", "arguments": [
		{"type": "mat_type", "name": "m"},
	], "priority": 0},
	{"return": "bvec_type", "name": "lessThan", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bvec_type", "name": "greaterThan", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bvec_type", "name": "lessThanEqual", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bvec_type", "name": "greaterThanEqual", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bvec_type", "name": "equal", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bvec_type", "name": "notEqual", "arguments": [
		{"type": "vec_type", "name": "x"},
		{"type": "vec_type", "name": "y"},
	], "priority": 0},
	{"return": "bool", "name": "any", "arguments": [
		{"type": "bvec_type", "name": "x"},
	], "priority": 0},
	{"return": "bool", "name": "all", "arguments": [
		{"type": "bvec_type", "name": "x"},
	], "priority": 0},
	{"return": "bvec_type", "name": "not", "arguments": [
		{"type": "bvec_type", "name": "x"},
	], "priority": 0},
	{"return": "ivec2", "name": "textureSize", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "ivec3", "name": "textureSize", "arguments": [
		{"type": "sampler2DArray_type", "name": "s"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "ivec3", "name": "textureSize", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "ivec2", "name": "textureSize", "arguments": [
		{"type": "samplerCube", "name": "s"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec2", "name": "uv"},
	], "priority": 5},
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec2", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 4},
	
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler2DArray_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler2DArray_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "samplerCube", "name": "s"},
		{"type": "vec3", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "texture", "arguments": [
		{"type": "samplerCube", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProj", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
		{"type": "float", "name": "bias"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "textureLod", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec2", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureLod", "arguments": [
		{"type": "sampler2DArray_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureLod", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureLod", "arguments": [
		{"type": "samplerCube", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProjLod", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec3", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProjLod", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "textureProjLod", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "vec4", "name": "uv"},
		{"type": "float", "name": "lod"},
	], "priority": 0},
	
	{"return": "vec4_type", "name": "texelFetch", "arguments": [
		{"type": "sampler2D_type", "name": "s"},
		{"type": "ivec2", "name": "uv"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "texelFetch", "arguments": [
		{"type": "sampler2DArray_type", "name": "s"},
		{"type": "ivec3", "name": "uv"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "vec4_type", "name": "texelFetch", "arguments": [
		{"type": "sampler3D_type", "name": "s"},
		{"type": "ivec3", "name": "uv"},
		{"type": "int", "name": "lod"},
	], "priority": 0},
	{"return": "vec_type", "name": "dFdx", "arguments": [
		{"type": "vec_type", "name": "p"},
	], "priority": 0},
	{"return": "vec_type", "name": "dFdy", "arguments": [
		{"type": "vec_type", "name": "p"},
	], "priority": 0},
	{"return": "vec_type", "name": "fwidth", "arguments": [
		{"type": "vec_type", "name": "p"},
	], "priority": 0},
]

class DictionarySorter:
	func sort_dictionaries(a, b) -> bool:
		if a.priority != b.priority:
			return a.priority >= b.priority
		return (a.name as String).casecmp_to(b.name as String) >= 0

var mouse_over := false
var clicked_this_frame := false

func _process(delta: float) -> void:
	clicked_this_frame = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var me := event as InputEventMouseButton
		if me.button_index == BUTTON_LEFT and me.pressed:
			clicked_this_frame = true
	if event is InputEventMouseMotion:
		var mpos = get_local_mouse_position()
		if ($PopupPanel.rect_position - mpos).length() > 10:
			if $PopupPanel.rect_position > mpos or $PopupPanel.rect_size < mpos - $PopupPanel.rect_position:
				$PopupPanel.hide()
		if mouse_over and not $PopupPanel.visible:
			$HoverTimer.start()
		else:
			$HoverTimer.stop()

const ExtendedShaderSingleton = preload("res://addons/sisilicon.shaders.extended-shader/ExtendedShaderSingleton.gd")

var word_char_regex = ExtendedShaderSingleton.create_reg_exp("^[a-zA-Z0-9_]$")
var word_regex = ExtendedShaderSingleton.create_reg_exp("^[a-zA-Z_][a-zA-Z0-9_]*$")

func is_word_character(c: String) -> bool:
	return word_char_regex.search(c)

func is_function_name(s: String) -> bool:
	return word_regex.search(s)

func _on_HoverTimer_timeout() -> void:
	#get_text_pos_at(get_local_mouse_position())
	var mpos = get_text_pos_at(get_local_mouse_position())
	var line = get_line(mpos[0])
	var look_at_pos = mpos[1]
	while look_at_pos >= 0 and look_at_pos < line.length() and is_word_character(line[look_at_pos]):
		look_at_pos -= 1
	var word_start = look_at_pos + 1
	look_at_pos = mpos[1]
	while look_at_pos >= 0 and look_at_pos < line.length() and is_word_character(line[look_at_pos]):
		look_at_pos += 1
	var word_end = look_at_pos
	var word = line.substr(word_start, word_end - word_start)
	if is_function_name(word):
		var funcs: Array = $"../Sprite".material.shader.functions
		var results = find_function(funcs, word)
		if results == []:
			results = find_function(BUILTIN_FUNCTIONS, word)
		if results == []:
			return
		var txt = ""
		for result in results:
			txt += result + "\n"
		txt = txt.trim_suffix("\n")
		$PopupPanel/Label.set_text(txt)
		$PopupPanel.popup(Rect2(get_viewport().get_mouse_position() + Vector2(1, 1), Vector2(2, 2)))

func find_function(funcs: Array, word: String) -> Array:
	var found := []
	funcs.sort_custom(DictionarySorter.new(), "sort_dictionaries")
	for fn in funcs:
		if fn["name"] == word:
			var txt = word + "("
			if fn.has("arguments"):
				var args = fn["arguments"]
				if args and args.size() > 0:
					for arg_idx in args.size() - 1:
						var arg = args[arg_idx]
						txt += arg["type"] + " " + arg["name"] + ", "
					txt += args[args.size() - 1]["type"] + " " + args[args.size() - 1]["name"]
			txt += ") -> " + fn["return"]
			found.push_back(txt)
	return found

func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false

func pos_at_mouse():
	get_text_pos_at(get_local_mouse_position())

func get_row_height():
	var line_spacing = get("custom_constants/line_spacing")
	if not typeof(line_spacing) == TYPE_INT:
		line_spacing = get_constant("line_spacing", "TextEdit")
	return get_font("font").get_height() + line_spacing

# Assumes we're using a monospace font
func get_char_width(c: String):
	assert(c.length() == 1)
	return get_font("font").get_char_size(c.ord_at(0)).x

func get_gutter_width():
	var width = 0
	if show_line_numbers:
		width += get_char_width('2') * (log(get_line_count() as float) as int + 1)
	if breakpoint_gutter:
		width += 10
	if fold_gutter:
		width += 10
	return width

func get_text_pos_at(p_mouse: Vector2):
	var text_height = get_row_height()
	var guessed_line = int(scroll_vertical + p_mouse.y / text_height)
	if get_line_count() - 1 < guessed_line:
		guessed_line = get_line_count() - 1
	else:
		var line_idx = 0
		while line_idx <= guessed_line:
			if is_line_hidden(line_idx):
				guessed_line = min(guessed_line + 1, get_line_count() - 1)
			line_idx += 1
	var guessed_row = -1
	var line = get_line(guessed_line)
	var total_width = get_gutter_width()
	for c_idx in line.length():
		var width = get_char_width(line[c_idx])
		if line[c_idx] == "\t":
			width = get_char_width(" ") * 4
		if total_width + width > p_mouse.x:
			if total_width + (width / 2) > p_mouse.x:
				guessed_row = c_idx
			else:
				guessed_row = c_idx + 1
			break
		total_width += width
	if guessed_row == -1:
		guessed_row = line.length()
	guessed_row = min(guessed_row, get_line(guessed_line).length())
	return [guessed_line, guessed_row]


func _on_TextEdit_cursor_changed() -> void:
	if clicked_this_frame:
		var pos = get_text_pos_at(get_local_mouse_position())
		if pos[0] != cursor_get_line() or pos[1] != cursor_get_column():
			printerr("positions did not match!")
