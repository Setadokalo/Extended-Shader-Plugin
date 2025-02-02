extends TextEdit

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

const ci_keys = [
	"TIME",
	"WORLD_MATRIX",
	"EXTRA_MATRIX",
	"PROJECTION_MATRIX",
	"INSTANCE_CUSTOM",
	"AT_LIGHT_PASS",
	"VERTEX",
	"TEXTURE_PIXEL_SIZE",
	"UV",
	"COLOR",
	"MODULATE",
	"POINT_SIZE",
	"FRAGCOORD",
	"NORMAL",
	"NORMALMAP",
	"NORMALMAP_DEPTH",
	"TEXTURE",
	"NORMAL_TEXTURE",
	"SCREEN_UV",
	"SCREEN_PIXEL_SIZE",
	"POINT_COORD",
	"SCREEN_TEXTURE",
]
const spatial_keys = [
	"VIEWPORT_SIZE",
	"WORLD_MATRIX",
	"INV_CAMERA_MATRIX",
	"PROJECTION_MATRIX",
	"CAMERA_MATRIX",
	"MODELVIEW_MATRIX",
	"INV_PROJECTION_MATRIX",
	"VERTEX",
	"POSITION",
	"NORMAL",
	"TANGENT",
	"BINORMAL",
	"ROUGHNESS",
	"UV",
	"UV2",
	"OUTPUT_IS_SRGB",
	"COLOR",
	"POINT_SIZE",
	"INSTANCE_ID",
	"INSTANCE_CUSTOM",
	"FRAGCOORD",
	"VIEW",
	"FRONT_FACING",
	"NORMALMAP",
	"NORMALMAP_DEPTH",
	"ALBEDO",
	"ALPHA",
	"ALPHA_SCISSOR",
	"METALLIC",
	"SPECULAR",
	"RIM",
	"RIM_TINT",
	"CLEARCOAT",
	"CLEARCOAT_GLOSS",
	"ANISOTROPY",
	"ANISOTROPY_FLOW",
	"SSS_STRENGTH",
	"TRANSMISSION",
	"EMISSION",
	"AO",
	"AO_LIGHT_AFFECT",
	"SCREEN_TEXTURE",
	"DEPTH_TEXTURE",
	"DEPTH",
	"SCREEN_UV",
	"POINT_COORD",
	"TIME",
	"LIGHT",
	"ATTENUATION",
	"LIGHT_COLOR",
	"DIFFUSE_LIGHT",
	"SPECULAR_LIGHT",
]
const particles_keys = [
	"TIME",
	"COLOR",
	"VELOCITY",
	"MASS",
	"ACTIVE",
	"RESTART",
	"CUSTOM",
	"TRANSFORM",
	"LIFETIME",
	"DELTA",
	"NUMBER",
	"INDEX",
	"EMISSION_TRANSFORM",
	"RANDOM_SEED",
]

var preproc_col := Color(0.631373, 1, 0.878431)
var keyword_col := Color(1, 0.439216, 0.521569)
var comment_col := Color(0.8, 0.807843, 0.827451, 0.501961)
var include_col := Color(1.0, 1.0, 0.7)
var builtin_include_col := Color("ffc996")

func _ready() -> void:
	reset_highlight_colors()

func set_popup_text(new_text: String) -> void:
	text = new_text
	var font = get_font("font")
	var max_width := 0.0
	for line in text.split("\n"):
		max_width = max(max_width, font.get_string_size(line).x)
	get_parent().set_size(Vector2(max_width + 8, 
			(font.get_height() + get_constant("line_spacing")) * get_line_count() + 4))


func reset_highlight_colors() -> void:
	clear_colors()
	for keyword in keywords:
		add_keyword_color(keyword, keyword_col)
	add_color_region("/*", "*/",  comment_col)
	add_color_region("//", "",    comment_col)
	add_color_region("\"", "\"",  include_col)
	add_color_region("<\"", ">",  builtin_include_col)
	add_color_region("/!!!!", "!!!!/", Color(1.0, 0.3, 0.3))
	add_keyword_color("define", preproc_col)
	add_keyword_color("undef", preproc_col)
	add_keyword_color("include", preproc_col)
	add_keyword_color("ifdef", preproc_col)
	add_keyword_color("ifndef", preproc_col)
	add_keyword_color("if", preproc_col)
	add_keyword_color("elif", preproc_col)
	add_keyword_color("else", preproc_col)
	add_keyword_color("endif", preproc_col)
	var type_key_col = keyword_col.linear_interpolate(Color(0.95, 0.6, 0.2), 0.8)
	add_keyword_color("vec_type", type_key_col)
	add_keyword_color("vec4_type", type_key_col)
	add_keyword_color("ivec_type", type_key_col)
	add_keyword_color("bvec_type", type_key_col)
	add_keyword_color("uvec_type", type_key_col)
	add_keyword_color("mat_type", type_key_col)
	add_keyword_color("sampler2D_type", type_key_col)
	add_keyword_color("sampler2DArray_type", type_key_col)
	add_keyword_color("sampler3D_type", type_key_col)
	add_keyword_color("samplerCube_type", type_key_col)
