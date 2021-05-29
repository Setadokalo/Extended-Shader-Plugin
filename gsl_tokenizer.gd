extends Object

const GslTokens = preload("res://Tokens.gd")
#TODO: add preprocessor constructs to tokenizer

static func get_operator(source: String, index: int):
	var c = source[index]
	match c:
		".":
			return GslTokens.Operator.MEMBER
		"=":
			if source[index + 1] == "=":
				return GslTokens.Operator.EQL
			else:
				return GslTokens.Operator.ASSIGN
		"+":
			return GslTokens.Operator.ADD
		"-":
			return GslTokens.Operator.SUBTRACT
		"!":
			if source[index + 1] == "=":
				return GslTokens.Operator.NEQL
			else:
				return GslTokens.Operator.NOT
		"~":
			return GslTokens.Operator.TILDE
		"*":
			return GslTokens.Operator.MULTIPLY
		"/":
			return GslTokens.Operator.DIVIDE
		"%":
			return GslTokens.Operator.MODULO
		"<":
			if source[index + 1] == "<":
				return GslTokens.Operator.BSHIFTL
			elif source[index + 1] == "=":
				return GslTokens.Operator.LSEQ
			else:
				return GslTokens.Operator.LESS
		">":
			if source[index + 1] == ">":
				return GslTokens.Operator.BSHIFTR
			elif source[index + 1] == "=":
				return GslTokens.Operator.GREQ
			else:
				return GslTokens.Operator.GRTR
		"&":
			if source[index + 1] == "&":
				return GslTokens.Operator.AND
			else:
				return GslTokens.Operator.BAND
		"|":
			if source[index + 1] == "|":
				return GslTokens.Operator.OR
			else:
				return GslTokens.Operator.BOR
		"^":
			return GslTokens.Operator.XOR
	return -1

static func get_whitespace(source: String, start_idx: int) -> String:
	var end_idx = start_idx
	var cont = true
	while cont:
		var c = source[end_idx]
		if not is_whitespace(c):
			if c == "/" and (source[end_idx + 1] == "/" or source[end_idx + 1] == "*"):
				var block := source[end_idx + 1] == "*"
				end_idx += 2
				if block:
					end_idx += 1
					while not (source[end_idx - 1] == "*" and source[end_idx] == "/"):
						end_idx += 1
					end_idx += 1
				else:
					while not source[end_idx] == "\n":
						end_idx += 1
			else:
				cont = false
				continue
		end_idx += 1
		if end_idx >= source.length():
			break
	return source.substr(start_idx, end_idx - start_idx)

static func is_whitespace(c: String) -> bool:
	if c == "\r" or c == "\n" or c == "\t" or c == "\f" or c == "\v" or c == " ":
		return true
	return false

var s0 = "0".ord_at(0)
var s9 = "9".ord_at(0)

func is_number_start(c: String) -> bool:
	var wc := c.ord_at(0)
	return s0 <= wc and wc <= s9

func get_number_at(source: String, start_idx: int) -> String:
	var end_idx = start_idx
	while is_number_start(source[end_idx]) or source[end_idx] == "." or \
			source[end_idx] == "f":
		end_idx += 1
		if end_idx >= source.length():
			break
	return source.substr(start_idx, end_idx - start_idx)

var word_char_regex := LibFuncs.create_reg_exp("[a-zA-Z_]")
var num_char_regex  := LibFuncs.create_reg_exp("\\w")

func is_word_char(c: String, allow_numbers: bool = false) -> bool:
	if allow_numbers:
		return num_char_regex.search(c) != null
	else:
		return word_char_regex.search(c) != null

const keywords := [
	# keywords
	"if",
	"else",
	"for",
	"while",
	"do",
	"switch",
	"case",
	"default",
	"break",
	"continue",
	"return",
	"discard",
	"render_mode",
	"shader_type",
]
const keyword_values := [
	# keyword-values
	"true",
	"false",
	"NULL",
]
const types := [
	# types
	"void",
	"bool",
	"bvec2",
	"bvec3",
	"bvec4",
	"int",
	"ivec2",
	"ivec3",
	"ivec4",
	"uint",
	"uvec2",
	"uvec3",
	"uvec4",
	"float",
	"vec2",
	"vec3",
	"vec4",
	"mat2",
	"mat3",
	"mat4",
	"sampler2D",
	"isampler2D",
	"usampler2D",
	"sampler2DArray",
	"isampler2DArray",
	"usampler2DArray",
	"sampler3D",
	"isampler3D",
	"usampler3D",
	"samplerCube",
	"samplerExternalOES",
]
const scope := [
	"const",
	"uniform",
	"varying",
]

const interpolation := [
	"flat",
	"smooth",
]

const arg_qualifiers := [
	# type modifiers
	"in",
	"out",
	"inout",
]

const precision_modifiers := [
	"lowp",
	"mediump",
	"highp",
]
const editor_hints := [
	# editor hints
	"hint_white",
	"hint_black",
	"hint_normal",
	"hint_aniso",
	"hint_albedo",
	"hint_black_albedo",
	"hint_color",
	"hint_range",
]

static func is_keyword(word: String) -> bool:
	return keywords.has(word)

static func is_keyword_value(word: String) -> bool:
	return keyword_values.has(word)

static func is_type(word: String) -> bool:
	return types.has(word)

static func is_scope(word: String) -> bool:
	return scope.has(word)

static func is_interpolation(word: String) -> bool:
	return interpolation.has(word)

static func is_qualifier(word: String) -> bool:
	return arg_qualifiers.has(word)

static func is_precision(word: String) -> bool:
	return precision_modifiers.has(word)

static func is_editor_hint(word: String) -> bool:
	return editor_hints.has(word)

func tokenize(shader_str: String) -> Array:
	var c_idx := 0
	var tokens := []
	while c_idx < shader_str.length():
		var c := shader_str[c_idx]
		if is_whitespace(c):
			var whitespace := get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			tokens.push_back(GslTokens.WhitespaceToken.new(whitespace))
		# elif the rest of the possible tokens
		elif is_word_char(c):
			var start_idx := c_idx
			while is_word_char(shader_str[c_idx], true):
				c_idx += 1
				if c_idx >= shader_str.length():
					break
			var word := shader_str.substr(start_idx, c_idx - start_idx)
			var whitespace = get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			if is_keyword(word):
				tokens.push_back(GslTokens.KeywordToken.new(word, whitespace))
			elif is_keyword_value(word):
				tokens.push_back(GslTokens.KeywordValueToken.new(word, whitespace))
			elif is_type(word):
				tokens.push_back(GslTokens.TypeToken.new(word, whitespace))
			elif is_scope(word):
				tokens.push_back(GslTokens.ScopeToken.new(word, whitespace))
			elif is_interpolation(word):
				tokens.push_back(GslTokens.InterpolationToken.new(word, whitespace))
			elif is_qualifier(word):
				tokens.push_back(GslTokens.ArgQualifierToken.new(word, whitespace))
			elif is_precision(word):
				tokens.push_back(GslTokens.TypePrecisionToken.new(word, whitespace))
			elif is_editor_hint(word):
				tokens.push_back(GslTokens.EditorHintToken.new(word, whitespace))
			else:
				tokens.push_back(GslTokens.IdentifierToken.new(word, whitespace))
		elif c == ";":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.SemicolonToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == ":":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.ColonToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == ",":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.CommaToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == "(":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.PAREN, true, whitespace))
			c_idx += whitespace.length()
		elif c == ")":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.PAREN, false, whitespace))
			c_idx += whitespace.length()
		elif c == "{":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.CURLY, true, whitespace))
			c_idx += whitespace.length()
		elif c == "}":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.CURLY, false, whitespace))
			c_idx += whitespace.length()
		elif c == "[":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.SQUARE, true, whitespace))
			c_idx += whitespace.length()
		elif c == "]":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(GslTokens.DelimToken.new(GslTokens.DelimiterType.SQUARE, false, whitespace))
			c_idx += whitespace.length()
		elif is_number_start(c):
			var num := get_number_at(shader_str, c_idx)
			c_idx += num.length()
			var whitespace = get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			var is_float = num.find(".") > 0 or num.ends_with("f")
			tokens.push_back(GslTokens.NumberToken.new(num, is_float, whitespace))
		else:
			var op = get_operator(shader_str, c_idx)
			if op != -1:
				c_idx += GslTokens.get_op_length(op)
				var whitespace = get_whitespace(shader_str, c_idx)
				c_idx += whitespace.length()
				tokens.push_back(GslTokens.OperatorToken.new(op, whitespace))
			else:
				printerr("failed to tokenize character '" + c + "'")
				return tokens
	return tokens
