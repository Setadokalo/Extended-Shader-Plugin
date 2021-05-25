extends "res://addons/sisilicon.shaders.extended-shader/ExtShaderTextEditor.gd"


func _on_TextEdit_symbol_lookup(symbol: String, row: int, column: int) -> void:
	print("looked up symbol ", symbol, " at position (%d, %d)" % [row, column])


func _on_TextEdit_request_completion() -> void:
	print("Requested completion")


func _on_TextEdit_info_clicked(row: int, info: String) -> void:
	print("clicked info on row ", row, " info ", info)

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
		$PopupPanel.hide()
		if mouse_over:
			$HoverTimer.start()
		else:
			$HoverTimer.stop()


func _on_HoverTimer_timeout() -> void:
	#get_text_pos_at(get_local_mouse_position())
	$PopupPanel.popup(Rect2(get_viewport().get_mouse_position() + Vector2(1, 1), Vector2(100, 20)))


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
