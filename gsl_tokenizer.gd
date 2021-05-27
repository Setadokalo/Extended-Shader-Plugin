extends Node

func _ready() -> void:
	# Tests the tokenizer
	print(tokenize("""    
	shader_type spatial;
	
	uniform vec3 factor;

	void fragment() {
		COLOR.rgb = vec3(0.5);
		COLOR.rgb *= factor;
	}
	"""))

enum TokenType {
	WORD,
	SEMICOLON,
	WHITESPACE,
	
	OPEN_PAREN,
	CLOSE_PAREN,
	
	OPEN_BRACE,
	CLOSE_BRACE,
	OPERATOR,
}

enum Operator {
	ADD,
	SUB,
	NOT,
	TILDE, # TODO: Proper name for this
	
	MUL,
	DIV,
	MOD,
	
	BSL, # bit shift left
	BSR, # bit shift right
	
	LSS,
	GRT,
	LEQ,
	GEQ,
	
	EQL,
	NEQ,
	
	BND,
	
	XOR,
	
	BOR,
	
	AND,
	
	IOR,
}

func tokenize(shader_str: String) -> Array:
	var c_idx := 0
	var tokens := []
	while c_idx < shader_str.length():
		var c := shader_str[c_idx]
		if is_whitespace(c):
			var start_idx = c_idx
			while is_whitespace(shader_str[c_idx]):
				c_idx += 1
			tokens.push_back(WhitespaceToken.new(shader_str.substr(start_idx, c_idx)))
		# elif the rest of the possible tokens
		elif is_word_char(c):
			var start_idx := c_idx
			while is_word_char(shader_str[c_idx], true):
				c_idx += 1
			var word := shader_str.substr(start_idx, c_idx - start_idx)
			var whitespace = get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			tokens.push_back(WordToken.new(word, whitespace))
		elif c == ";":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(SemicolonToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == "(":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(OpenParenToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == ")":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(CloseParenToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == "{":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(OpenBraceToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == "}":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(CloseBraceToken.new(whitespace))
			c_idx += whitespace.length()
		else:
			printerr("failed to tokenize character '" + c + "'")
			return tokens
	return tokens

func get_whitespace(source: String, start_idx: int) -> String:
	var end_idx = start_idx
	while is_whitespace(source[end_idx]):
		end_idx += 1
	return source.substr(start_idx, end_idx - start_idx)

func is_whitespace(c: String) -> bool:
	if c == "\r" or c == "\n" or c == "\t" or c == "\f" or c == "\v" or c == " ":
		return true
	return false

var word_char_regex := create_reg_exp("[a-zA-Z_]")
var num_char_regex := create_reg_exp("\\w")

func is_word_char(c: String, allow_numbers: bool = false) -> bool:
	if allow_numbers:
		return num_char_regex.search(c) != null
	else:
		return word_char_regex.search(c) != null

class Token:
	var TYPE: int = 0 setget set_type, get_type
	var whitespace: String
	func set_type(_newval: int):
		# you fool! you can't set the type after initialization!
		printerr("Attempted to change token type!")
	
	func get_type() -> int:
		return TYPE
		
	func _init(type: int, _whitespace: String) -> void:
		TYPE = type
		whitespace = _whitespace
		
	func ws_to_string() -> String:
		var debug_str := "whitespace: \""
		for c in whitespace:
			if c == " ":
				debug_str += " "
			elif c == "\r":
				debug_str += "\\r"
			elif c == "\n":
				debug_str += "\\n"
			elif c == "\t":
				debug_str += "\\t"
			elif c == "\f":
				debug_str += "\\f"
			elif c == "\v":
				debug_str += "\\v"
		return debug_str + "\""

class WordToken extends Token:
	var word: String
	func _init(chars: String, ws: String).(TokenType.WORD, ws) -> void:
		word = chars
		
	func _to_string() -> String:
		return "WordToken{\"" + word + "\", " + ws_to_string() + "}"

class SemicolonToken extends Token:
	func _init(ws: String).(TokenType.SEMICOLON, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "SemicolonToken{" + ws_to_string() + "}"

class OpenParenToken extends Token:
	func _init(ws: String).(TokenType.OPEN_PAREN, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "OpenParenToken{" + ws_to_string() + "}"

class CloseParenToken extends Token:
	func _init(ws: String).(TokenType.CLOSE_PAREN, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "CloseParenToken{" + ws_to_string() + "}"

class OpenBraceToken extends Token:
	func _init(ws: String).(TokenType.OPEN_BRACE, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "OpenBraceToken{" + ws_to_string() + "}"

class CloseBraceToken extends Token:
	func _init(ws: String).(TokenType.CLOSE_BRACE, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "CloseBraceToken{" + ws_to_string() + "}"

# Whitespace Tokens should almost exclusively exist at the start of a file - all other
# whitespace should be contained in the previous token
class WhitespaceToken extends Token:
	func _init(chars: String).(TokenType.WHITESPACE, chars) -> void:
		whitespace = chars
	
	func _to_string() -> String:
		return "WhitespaceToken{" + ws_to_string() + "}"



static func create_reg_exp(string : String) -> RegEx:
	var reg_exp := RegEx.new()
	reg_exp.compile(string)
	
	if not reg_exp.is_valid():
		printerr("'" + string + "' is not a valid regular expression!")
	
	return reg_exp

