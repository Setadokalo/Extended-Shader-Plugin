extends Node

const GslTokens = preload("res://Tokens.gd")
const Lib = preload("res://Libfuncs.gd")
const Pair = Lib.Pair

#TODO: add parsing logic for currently-unimplemented preprocessor tokens
#TODO: add parsing logic for all other tokens lol

# returns an error dictionary if there are not enough arguments for this token.
# arg_count should be the number of additional tokens this token needs for parsing, 
# INCLUDING a semicolon (if applicable).
func not_enough_arguments(source: Array, idx: int, arg_count: int):
	if source.size() < idx + arg_count:
		return {
			"error": "not enough argument tokens for token", 
			"pos": idx
		}
func missing_semicolon(source: Array, idx: int):
	if not source[idx] is GslTokens.SemicolonToken:
		return {
			"error": "expected semicolon", 
			"pos": idx
		}

# parses a token tree (assuming global state)
func parse(tokens: Array):
	var shader_type := -1
	var render_modes := []
	var function_table := {}
	var var_table := {}
	var c_idx := 0
	if tokens[0] is GslTokens.WhitespaceToken:
		c_idx += 1
	while c_idx < tokens.size():
		var token = tokens[c_idx]
		var parsed_token := false
		if token is GslTokens.KeywordToken:
			if token.word == "shader_type":
				# arguments: type, semicolon
				var error = not_enough_arguments(tokens, c_idx, 2)
				if error: return error
				var type = tokens[c_idx + 1]
				if not type is GslTokens.IdentifierToken:
					return {
						"error": "invalid shader type token", 
						"pos": c_idx
					}
				if get_shader_type(type.word) == -1:
					return {
						"error": "shader_type must be 'spatial', 'canvas_item', or 'particle'", 
						"pos": c_idx
					}
				error = missing_semicolon(tokens, c_idx + 2)
				if error: return error
				shader_type = get_shader_type(type.word)
				parsed_token = true
				c_idx += 3
			elif token.word == "render_mode":
				if shader_type == -1:
					return {
						"error": "shader_type must be first non-preprocessor token in file", 
						"pos": c_idx
					}
				while not tokens[c_idx] is GslTokens.SemicolonToken and c_idx < tokens.size():
					if tokens[c_idx] is GslTokens.IdentifierToken:
						if not tokens[c_idx] is GslTokens.IdentifierToken \
							or not is_render_mode(shader_type, tokens[c_idx].word):
							return {
								"error": "invalid render mode '" + tokens[c_idx].to_string() + "'",
								"pos": c_idx
							}
						if render_modes.has(tokens[c_idx].word):
							return {
								"error": "duplicate render mode '" + tokens[c_idx].word + "'",
								"pos": c_idx
							}
						if tokens[c_idx + 1] is GslTokens.CommaToken:
							c_idx += 2
						elif not tokens[c_idx + 1] is GslTokens.SemicolonToken:
							return {
								"error": "render modes should be followed by a comma or semicolon",
								"pos": c_idx
							}
						render_modes.append(tokens[c_idx].word)
					c_idx += 1
				c_idx += 1
				parsed_token = true
		elif token is GslTokens.TypeToken or token is GslTokens.TypeToken:
			var result := parse_declaration(tokens, c_idx, var_table, function_table)
			if result.one is Dictionary:
				return result.one
			#TODO: store result of parse_declaration
			c_idx = result.two

		if shader_type == -1:
			return {
				"error": "shader_type must be first non-preprocessor token in file", 
				"pos": c_idx
			}
		if not parsed_token:
			return {
				"error": "Invalid or unimplemented token '" + token.to_string() + "'", 
				"pos": c_idx
			}

const spatial_modes := [
	"blend_mix",
	"blend_add",
	"blend_sub",
	"blend_mul",
	"depth_draw_opaque",
	"depth_draw_always",
	"depth_draw_never",
	"depth_draw_alpha_prepass",
	"depth_test_disable",
	"cull_front",
	"cull_back",
	"cull_disabled",
	"unshaded",
	"diffuse_lambert",
	"diffuse_lambert_wrap",
	"diffuse_oren_nayar",
	"diffuse_burley",
	"diffuse_toon",
	"specular_schlick_ggx",
	"specular_blinn",
	"specular_phong",
	"specular_toon",
	"specular_disabled",
	"skip_vertex_transform",
	"world_vertex_coords",
	"ensure_correct_normals",
	"vertex_lighting",
	"shadows_disabled",
	"ambient_light_disabled",
	"shadow_to_opacity",
]
const canvas_item_modes := [
	"blend_mix",
	"blend_add",
	"blend_sub",
	"blend_mul",
	"blend_premul_alpha",
	"blend_disabled",
	"unshaded",
	"light_only",
	"skip_vertex_transform",
]
const particles_modes := [
	"keep_data",
	"disable_force",
	"disable_velocity",
]

func error(error: String, idx: int) -> Dictionary:
	return {"error": error, "pos": idx}

func is_render_mode(shader_type: int, mode: String) -> bool:
	match shader_type:
		Shader.MODE_SPATIAL:
			return spatial_modes.has(mode)
		Shader.MODE_CANVAS_ITEM:
			return canvas_item_modes.has(mode)
		Shader.MODE_PARTICLES:
			return particles_modes.has(mode)
	return false

# parses a global scope declaration without modifiers (TYPE IDENT[(ARGS) {} | = STATEMENT;])
# with modifier declarations will be handled by a seperate, variable-only function
# (this function must distinguish between variables and functions)
func parse_declaration(tokens: Array, start: int, var_table: Dictionary, function_table: Dictionary) -> Pair:
	var c_idx = start
	if not tokens[c_idx] is GslTokens.TypeToken:
		return Pair.new(error("Attempted to parse typed-declaration with no type!", c_idx), c_idx)
	var type: String = tokens[c_idx].word
	c_idx += 1
	if not tokens[c_idx] is GslTokens.IdentifierToken:
		return Pair.new(error("Invalid Identifier!", c_idx), c_idx)
	var ident: String = tokens[c_idx].word
	c_idx += 1
	if not tokens[c_idx] is GslTokens.DelimToken \
			or tokens[c_idx].delimiter != GslTokens.DelimiterType.PAREN \
			or not tokens[c_idx].opening:
		return Pair.new(error("Expected '('", c_idx), c_idx)
	var parameters := []
	var end_of_params := false
	
	c_idx += 1
	return null

func parse_func(
		tokens: Array, 
		start: int, 
		return_type: String, 
		var_table: Dictionary, 
		function_table: Dictionary) -> Pair:
	printerr("function parsing is weak")
	var nest_level := 1
	var c_idx := start
	var function_tokens := []
	while c_idx < tokens.size():
		var token: GslTokens.Token = tokens[c_idx]
		if token is GslTokens.DelimToken:
			if token.delimiter == GslTokens.DelimiterType.CURLY:
				if token.opening:
					nest_level += 1
				else:
					nest_level -= 1
					# nest level 1 means we are in the function scope
					# level 0 means we have left the function
					if nest_level == 0:
						break
		function_tokens.append(token)
		c_idx += 1
	return Pair.new(function_tokens, c_idx + 1)

static func get_shader_type(s: String) -> int:
	match s:
		"spatial": return Shader.MODE_SPATIAL
		"canvas_item": return Shader.MODE_CANVAS_ITEM
		"particles": return Shader.MODE_PARTICLES
	return -1
