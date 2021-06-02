extends Object


enum TokenType {
	WORD,
	KEYWORD,
	IDENTIFIER,
	NUMBER,
	SEMICOLON,
	COLON,
	COMMA,
	WHITESPACE,
	
	DELIM,
	OPERATOR,
}

enum Operator {
	ASSIGN,   # =
	MEMBER,   # . # short for access member
	
	ADD,      # +
	SUBTRACT, # -
	NOT,      # !
	TILDE,    # ~ # TODO: Proper name for this
	
	MULTIPLY, # *
	DIVIDE,   # /
	MODULO,   # %
	
	BSHIFTL,  # << # bit shift left
	BSHIFTR,  # >> # bit shift right
	
	LESS,     # <
	GRTR,     # >
	LSEQ,     # <=
	GREQ,     # >=
	EQL,      # ==
	NEQL,     # !=
	
	AND,      # &&
	OR,       # ||
	
	XOR,      # ^
	BAND,     # &
	BOR,      # |
}

static func get_op_length(op: int) -> int:
	match op:
		Operator.ASSIGN: return 1
		Operator.MEMBER: return 1
		Operator.ADD: return 1
		Operator.SUBTRACT: return 1
		Operator.NOT: return 1
		Operator.TILDE: return 1
		Operator.MULTIPLY: return 1
		Operator.DIVIDE: return 1
		Operator.MODULO: return 1
		Operator.XOR: return 1
		Operator.BAND: return 1
		Operator.BOR: return 1
		Operator.LESS: return 1
		Operator.GRTR: return 1
		
		Operator.BSHIFTL: return 2
		Operator.BSHIFTR: return 2
		Operator.LSEQ: return 2
		Operator.GREQ: return 2
		Operator.EQL: return 2
		Operator.NEQL: return 2
		Operator.AND: return 2
		Operator.OR: return 2
	
	printerr("invalid operator!")
	return 0

enum DelimiterType {
	CURLY,
	SQUARE,
	PAREN,
}

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
#		return ""
		var debug_str := "whitespace: \""
		for c in whitespace:
			if c == "\r":
				debug_str += "\\r"
			elif c == "\n":
				debug_str += "\\n"
			elif c == "\t":
				debug_str += "\\t"
			elif c == "\f":
				debug_str += "\\f"
			elif c == "\v":
				debug_str += "\\v"
			elif c == "\\":
				debug_str += "\\\\"
			else:
				debug_str += c
		return debug_str + "\""

class WordToken extends Token:
	var word: String
	func _init(chars: String, ws: String).(TokenType.KEYWORD, ws) -> void:
		word = chars
		
	func _to_string() -> String:
		return "WordToken{\"" + word + "\", " + ws_to_string() + "}"

class KeywordToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
		
	func _to_string() -> String:
		return "KeywordToken{\"" + word + "\", " + ws_to_string() + "}"

class KeywordValueToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "KeywordValueToken{\"" + word + "\", " + ws_to_string() + "}"

class EditorHintToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "EditorHintToken{\"" + word + "\", " + ws_to_string() + "}"

class TypeToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "TypeToken{\"" + word + "\", " + ws_to_string() + "}"

class ScopeToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "ScopeToken{\"" + word + "\", " + ws_to_string() + "}"

class InterpolationToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "InterpolationToken{\"" + word + "\", " + ws_to_string() + "}"

class ArgQualifierToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "ArgQualifierToken{\"" + word + "\", " + ws_to_string() + "}"

class TypePrecisionToken extends WordToken:
	func _init(chars: String, ws: String).(chars, ws) -> void:
		pass
	func _to_string() -> String:
		return "TypePrecisionToken{\"" + word + "\", " + ws_to_string() + "}"


class IdentifierToken extends Token:
	var word: String
	func _init(chars: String, ws: String).(TokenType.IDENTIFIER, ws) -> void:
		word = chars
		
	func _to_string() -> String:
		return "IdentifierToken{\"" + word + "\", " + ws_to_string() + "}"


class NumberToken extends Token:
	var number: String
	var is_float: bool
	func _init(chars: String, is_float_: bool, ws: String).(TokenType.WORD, ws) -> void:
		number = chars
		is_float = is_float_
		
	func _to_string() -> String:
		return "NumberToken{is_float: " + String(is_float) + ", number: " + number + ", " + ws_to_string() + "}"

class SemicolonToken extends Token:
	func _init(ws: String).(TokenType.SEMICOLON, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "SemicolonToken{" + ws_to_string() + "}"

class ColonToken extends Token:
	func _init(ws: String).(TokenType.COLON, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "ColonToken{" + ws_to_string() + "}"

class CommaToken extends Token:
	func _init(ws: String).(TokenType.COMMA, ws) -> void:
		pass
	
	func _to_string() -> String:
		return "CommaToken{" + ws_to_string() + "}"

class DelimToken extends Token:
	var opening: bool
	var delimiter: int
	func _init(delimiter_: int, opening_: bool, ws: String).(TokenType.DELIM, ws) -> void:
		opening = opening_
		delimiter = delimiter_
	
	func to_string_delim() -> String:
		match delimiter:
			DelimiterType.CURLY:
				return "{" if opening else "}"
			DelimiterType.SQUARE:
				return "[" if opening else "]"
			DelimiterType.PAREN:
				return "(" if opening else ")"
		printerr("Invalid Delimiter!")
		return "<invalid delimiter>"
	
	func _to_string() -> String:
		return "DelimToken{delimiter: '" + to_string_delim() + "', " + ws_to_string() + "}"

class OperatorToken extends Token:
	var operator: int
	func _init(op: int, ws: String).(TokenType.OPERATOR, ws) -> void:
		operator = op
	
	func op_to_string() -> String:
		match operator:
			Operator.ASSIGN: return "="
			Operator.MEMBER: return "."
			Operator.ADD: return "+"
			Operator.SUBTRACT: return "-"
			Operator.NOT: return "!"
			Operator.TILDE: return "~"
			Operator.MULTIPLY: return "*"
			Operator.DIVIDE: return "/"
			Operator.MODULO: return "%"
			Operator.XOR: return "^"
			Operator.BAND: return "&"
			Operator.BOR: return "|"
			Operator.LESS: return "<"
			Operator.GRTR: return ">"
			
			Operator.BSHIFTL: return "<<"
			Operator.BSHIFTR: return ">>"
			Operator.LSEQ: return "<="
			Operator.GREQ: return ">="
			Operator.EQL: return "=="
			Operator.NEQL: return "!="
			Operator.AND: return "&&"
			Operator.OR: return "||"
		printerr("Invalid operator!")
		return ""
	
	func _to_string() -> String:
		return "OperatorToken{op: '" + op_to_string() + "', " + ws_to_string() + " }"
# Whitespace Tokens should almost exclusively exist at the start of a file - all other
# whitespace should be contained in the previous token
class WhitespaceToken extends Token:
	func _init(chars: String).(TokenType.WHITESPACE, chars) -> void:
		whitespace = chars
	
	func _to_string() -> String:
		return "WhitespaceToken{" + ws_to_string() + "}"
