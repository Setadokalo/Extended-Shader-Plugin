extends TextEdit

export var symbol_color: Color
export var quote_color: Color
export var bool_color: Color

export var keyword_token_color: Color
export var identifier_token_color: Color
export var number_token_color: Color
export var semicolon_token_color: Color
export var whitespace_token_color: Color
export var delim_token_color: Color
export var op_token_color: Color

func _ready() -> void:
	add_color_region("'", "'", symbol_color)
	add_color_region("\"", "\"", quote_color)
	add_keyword_color("True", bool_color)
	add_keyword_color("False", bool_color)
	add_keyword_color("KeywordToken", keyword_token_color)
	add_keyword_color("IdentifierToken", identifier_token_color)
	add_keyword_color("NumberToken", number_token_color)
	add_keyword_color("SemicolonToken", semicolon_token_color)
	add_keyword_color("WhitespaceToken", whitespace_token_color)
	add_keyword_color("DelimToken", delim_token_color)
	add_keyword_color("OperatorToken", op_token_color)
	# Tests the tokenizer
	print("Preparing to tokenize...")
	var time = OS.get_ticks_usec()
	var tokenized := tokenize("""    
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		shader_type canvas_item;
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		// Modulo 289 without a division (only multiplications)
		vec4 mod289_4(vec4 x) {
			int i = .5;
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		vec3 mod289_3(vec3 x) {
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		vec2 mod289_2(vec2 x) {
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		float mod289(float x) {
			return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		// Modulo 7 without a division
		vec3 mod7_3(vec3 x) {
			return x - floor(x * (1.0 / 7.0)) * 7.0;
		}

		vec4 mod7_4(vec4 x) {
		  return x - floor(x * (1.0 / 7.0)) * 7.0;
		}

		float permute(float x) {
			return mod289(((x * 34.0) + 1.0) * x);
		}

		// Permutation polynomial: (34x^2 + x) mod 289
		vec3 permute_3(vec3 x) {
			return mod289_3((34.0 * x + 1.0) * x);
		}

		// Permutation polynomial: (34x^2 + x) mod 289
		vec4 permute_4(vec4 x) {
		  return mod289_4((34.0 * x + 1.0) * x);
		}

		vec4 taylorInvSqrt_4(vec4 r) {
			return 1.79284291400159 - 0.85373472095314 * r;
		}

		float taylorInvSqrt(float r) {
			return 2.79284291400159 - 1.85373472095314 * r;
		}

		vec2 fade_2(vec2 t) {
			return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
		}

		vec3 fade_3(vec3 t) {
			return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
		}

		vec4 fade_4(vec4 t) {
			return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
		}

		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

		// Description : Array and textureless GLSL 2D/3D/4D simplex 
		//               noise functions.
		//      Author : Ian McEwan, Ashima Arts.
		//  Maintainer : stegu
		//     Lastmod : 20110822 (ijm)
		//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
		//               Distributed under the MIT License. See LICENSE file.
		//               https://github.com/ashima/webgl-noise
		//               https://github.com/stegu/webgl-noise
		// 

		float snoise3d(vec3 v) { 
			vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
			vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
			
			// First corner
			vec3 i  = floor(v + dot(v, vec3(C.y)) );
			vec3 x0 = v - i + dot(i, vec3(C.x)) ;
			
			// Other corners
			vec3 g = step(x0.yzx, x0.xyz);
			vec3 l = 1.0 - g;
			vec3 i1 = min( g.xyz, l.zxy );
			vec3 i2 = max( g.xyz, l.zxy );
			
			//   x0 = x0 - 0.0 + 0.0 * C.xxx;
			//   x1 = x0 - i1  + 1.0 * C.xxx;
			//   x2 = x0 - i2  + 2.0 * C.xxx;
			//   x3 = x0 - 1.0 + 3.0 * C.xxx;
			vec3 x1 = x0 - i1 + vec3(C.x);
			vec3 x2 = x0 - i2 + vec3(C.y); // 2.0*C.x = 1/3 = C.y
			vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
			
			// Permutations
			i = mod289_3(i); 
			vec4 p = permute_4( permute_4( permute_4( 
					 i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
				   + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
				   + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
			
			// Gradients: 7x7 points over a square, mapped onto an octahedron.
			// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
			float n_ = 0.142857142857; // 1.0/7.0
			vec3  ns = n_ * D.wyz - D.xzx;
			
			vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
			
			vec4 x_ = floor(j * ns.z);
			vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
			
			vec4 x = x_ *ns.x + vec4(ns.y);
			vec4 y = y_ *ns.x + vec4(ns.y);
			vec4 h = 1.0 - abs(x) - abs(y);
			
			vec4 b0 = vec4( x.xy, y.xy );
			vec4 b1 = vec4( x.zw, y.zw );
			
			//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
			//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
			vec4 s0 = floor(b0)*2.0 + 1.0;
			vec4 s1 = floor(b1)*2.0 + 1.0;
			vec4 sh = -step(h, vec4(0.0));
			
			vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
			vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
			
			vec3 p0 = vec3(a0.xy,h.x);
			vec3 p1 = vec3(a0.zw,h.y);
			vec3 p2 = vec3(a1.xy,h.z);
			vec3 p3 = vec3(a1.zw,h.w);
			
			//Normalise gradients
			vec4 norm = taylorInvSqrt_4(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
			p0 *= norm.x;
			p1 *= norm.y;
			p2 *= norm.z;
			p3 *= norm.w;
			
			// Mix final noise value
			vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), vec4(0.0));
			m = m * m;
			return 22.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );
		}

		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/

		float texture(sampler2D sampler, vec2 uv) {return 0.0;}

		void fragment() {
			COLOR = texture(TEXTURE, UV);
			COLOR.rgb *= vec3(snoise3d(vec3(UV * 5.0, TIME)), 
							  snoise3d(vec3(UV * 5.0 + vec2(1000.0), TIME)), 
							  snoise3d(vec3(UV * 5.0 + vec2(2000.0), TIME)))
				/ 2.0 + 0.5;
		}
	""")
	var elapsed_micros = OS.get_ticks_usec() - time
	print("Tokenized in %f seconds. Displaying..." % ((elapsed_micros as float) / 1000000.0))
	time = OS.get_ticks_usec()
	var temp_text := ""
	var first_token = true
	for token in tokenized:
		if not first_token:
			if (token as Token).TYPE == TokenType.WHITESPACE:
				# Whitespace tokens should only exist to consume leading whitespace in the file
				printerr("Non-first Whitespace Token detected!")
		else:
			first_token = false
		temp_text += token.to_string() + "\n"
	text = temp_text
	elapsed_micros = OS.get_ticks_usec() - time
	print("Displayed in %f seconds." % ((elapsed_micros as float) / 1000000.0))
	
enum TokenType {
	WORD,
	KEYWORD,
	IDENTIFIER,
	NUMBER,
	SEMICOLON,
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

func get_operator(source: String, index: int):
	var c = source[index]
	match c:
		".":
			return Operator.MEMBER
		"=":
			if source[index + 1] == "=":
				return Operator.EQL
			else:
				return Operator.ASSIGN
		"+":
			return Operator.ADD
		"-":
			return Operator.SUBTRACT
		"!":
			if source[index + 1] == "=":
				return Operator.NEQL
			else:
				return Operator.NOT
		"~":
			return Operator.TILDE
		"*":
			return Operator.MULTIPLY
		"/":
			return Operator.DIVIDE
		"%":
			return Operator.MODULO
		"<":
			if source[index + 1] == "<":
				return Operator.BSHIFTL
			elif source[index + 1] == "=":
				return Operator.LSEQ
			else:
				return Operator.LESS
		">":
			if source[index + 1] == ">":
				return Operator.BSHIFTR
			elif source[index + 1] == "=":
				return Operator.GREQ
			else:
				return Operator.GRTR
		"&":
			if source[index + 1] == "&":
				return Operator.AND
			else:
				return Operator.BAND
		"|":
			if source[index + 1] == "|":
				return Operator.OR
			else:
				return Operator.BOR
		"^":
			return Operator.XOR
	return -1

func get_op_length(op: int) -> int:
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

func tokenize(shader_str: String) -> Array:
	var c_idx := 0
	var tokens := []
	while c_idx < shader_str.length():
		var c := shader_str[c_idx]
		if is_whitespace(c):
			var whitespace := get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			tokens.push_back(WhitespaceToken.new(whitespace))
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
				tokens.push_back(KeywordToken.new(word, whitespace))
			else:
				tokens.push_back(IdentifierToken.new(word, whitespace))
		elif c == ";":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(SemicolonToken.new(whitespace))
			c_idx += whitespace.length()
		elif c == "(":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.PAREN, true, whitespace))
			c_idx += whitespace.length()
		elif c == ")":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.PAREN, false, whitespace))
			c_idx += whitespace.length()
		elif c == "{":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.CURLY, true, whitespace))
			c_idx += whitespace.length()
		elif c == "}":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.CURLY, false, whitespace))
			c_idx += whitespace.length()
		elif c == "[":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.SQUARE, true, whitespace))
			c_idx += whitespace.length()
		elif c == "]":
			c_idx += 1
			var whitespace = get_whitespace(shader_str, c_idx)
			tokens.push_back(DelimToken.new(DelimiterType.SQUARE, false, whitespace))
			c_idx += whitespace.length()
		elif is_number_start(c):
			var num := get_number_at(shader_str, c_idx)
			c_idx += num.length()
			var whitespace = get_whitespace(shader_str, c_idx)
			c_idx += whitespace.length()
			var is_float = num.find(".") > 0 or num.ends_with("f")
			tokens.push_back(NumberToken.new(num, is_float, whitespace))
		else:
			var op = get_operator(shader_str, c_idx)
			if op != -1:
				c_idx += get_op_length(op)
				var whitespace = get_whitespace(shader_str, c_idx)
				c_idx += whitespace.length()
				tokens.push_back(OperatorToken.new(op, whitespace))
			else:
				printerr("failed to tokenize character '" + c + "'")
				return tokens
	return tokens

func get_whitespace(source: String, start_idx: int) -> String:
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

func is_whitespace(c: String) -> bool:
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
var word_char_regex := create_reg_exp("[a-zA-Z_]")
var num_char_regex := create_reg_exp("\\w")

func is_word_char(c: String, allow_numbers: bool = false) -> bool:
	if allow_numbers:
		return num_char_regex.search(c) != null
	else:
		return word_char_regex.search(c) != null

const keywords = [
	"true",
	"false",
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
	"flat",
	"smooth",
	"const",
	"lowp",
	"mediump",
	"highp",
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
	"uniform",
	"varying",
	"in",
	"out",
	"inout",
	"render_mode",
	"hint_white",
	"hint_black",
	"hint_normal",
	"hint_aniso",
	"hint_albedo",
	"hint_black_albedo",
	"hint_color",
	"hint_range",
	"shader_type",
	"NULL"
]

func is_keyword(word: String) -> bool:
	return keywords.has(word)

var operator_regex := create_reg_exp("")

func is_operator(c: String) -> bool:
	return false

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

class KeywordToken extends Token:
	var word: String
	func _init(chars: String, ws: String).(TokenType.KEYWORD, ws) -> void:
		word = chars
		
	func _to_string() -> String:
		return "KeywordToken{\"" + word + "\", " + ws_to_string() + "}"

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

enum DelimiterType {
	CURLY,
	SQUARE,
	PAREN,
}

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



static func create_reg_exp(string : String) -> RegEx:
	var reg_exp := RegEx.new()
	reg_exp.compile(string)
	
	if not reg_exp.is_valid():
		printerr("'" + string + "' is not a valid regular expression!")
	
	return reg_exp

