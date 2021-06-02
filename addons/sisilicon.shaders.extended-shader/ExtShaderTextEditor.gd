tool
extends AdvancedTextEdit

const ExtendedShaderSingleton := preload("res://addons/sisilicon.shaders.extended-shader/ExtendedShaderSingleton.gd")

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

var cur_hl_mode = -1

var shader: Shader = null

#func get_setting(name: String):
#	return null

func _ready() -> void:
	._ready()
	reset_highlight_colors()

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


func set_shader_mode(mode: int):
	# as an improvement over the default shader editor,
	# we only highlight keywords for the current shader type
	if mode != cur_hl_mode:
		reset_highlight_colors()
		if mode == Shader.MODE_CANVAS_ITEM:
			for keyword in ci_keys:
				add_keyword_color(keyword, keyword_col)
			cur_hl_mode = mode
		elif mode == Shader.MODE_SPATIAL:
			for keyword in spatial_keys:
				add_keyword_color(keyword, keyword_col)
			cur_hl_mode = mode
		elif mode == Shader.MODE_PARTICLES:
			for keyword in particles_keys:
				add_keyword_color(keyword, keyword_col)
			cur_hl_mode = mode

var word_regex = ExtendedShaderSingleton.create_reg_exp("^[a-zA-Z_][a-zA-Z0-9_]*$")

func is_function_name(s: String) -> bool:
	return word_regex.search(s)

class DictionarySorter:
	func sort_dictionaries(a, b) -> bool:
		if a.priority != b.priority:
			return a.priority >= b.priority
		return (a.name as String).casecmp_to(b.name as String) >= 0

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

func _get_popup_text(mouse_pos: Vector2) -> String:
	print("popup triggered")
	if not shader:
		printerr("Attempted popup without shader")
		return ""
	var mpos = get_text_pos_at(mouse_pos)
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
		var funcs: Array = shader.functions
		var results = find_function(funcs, word)
		if results == []:
			results = find_function(BUILTIN_FUNCTIONS, word)
		if results == []:
			return ""
		var txt = ""
		for result in results:
			txt += result + "\n"
		txt = txt.trim_suffix("\n")
		return txt
	return ""
