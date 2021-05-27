extends "res://addons/sisilicon.shaders.extended-shader/ExtShaderTextEditor.gd"




func set_text(new_text: String) -> void:
	text = new_text
	var font = get_font("font")
	var max_width := 0.0
	for line in text.split("\n"):
		max_width = max(max_width, font.get_string_size(line).x)
	rect_min_size = Vector2(max_width + 12, 
			(font.get_height() + get_constant("line_spacing")) * get_line_count() + 5)
	rect_size = rect_min_size
	get_parent().set_size(rect_min_size)

func reset_highlight_colors() -> void:
	.reset_highlight_colors()
	var type_key_col = keyword_col.linear_interpolate(Color(0.55, 0.3, 0.2), 0.8)
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
