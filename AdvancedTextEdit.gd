tool
extends TextEdit
class_name AdvancedTextEdit

const Lib := preload("res://Libfuncs.gd")
const PopupTextEdit := preload("res://PopupTextEdit.gd")
const PopupTextEditTheme := preload("res://PopupTextEditTheme.tres")

export var highlight_color: Color = Color(0.8, 0.8, 0.8, 0.4)
export var error_color: Color = Color(0.8, 0.0, 0.0, 0.4)

var readonly_style: StyleBox
var focus_style: StyleBox
var normal_style: StyleBox

var bg_panel: Panel
var focus_panel: Panel
var line_highlight := ColorRect.new()
var line_error := ColorRect.new()
var word_error := ColorRect.new()
var hover_timer := Timer.new()

var popup_panel := PopupPanel.new()

func _init() -> void:
	hover_timer.wait_time = 0.5
	hover_timer.one_shot = true
	var popup_text_holder = PopupTextEdit.new()
	popup_panel.theme = PopupTextEditTheme
#	popup_text_holder.set_script(PopupTextEdit.new())
	popup_panel.add_child(popup_text_holder)
	popup_text_holder.syntax_highlighting = true
	popup_text_holder.anchor_right = 1
	popup_text_holder.anchor_bottom = 1
	popup_text_holder.margin_right = 0
	popup_text_holder.margin_bottom = 0
	
	line_highlight.anchor_right = 1
	line_highlight.margin_right = 0
	line_highlight.mouse_filter = MOUSE_FILTER_IGNORE
	line_highlight.show_behind_parent = true
	line_highlight.rect_size.y = get_row_height()
	
	line_error.anchor_right = 1
	line_error.margin_right = 0
	line_error.mouse_filter = MOUSE_FILTER_IGNORE
	line_error.show_behind_parent = true
	
	word_error.mouse_filter = MOUSE_FILTER_IGNORE
	word_error.show_behind_parent = true
	
	bg_panel = Panel.new()
	bg_panel.anchor_right = 1
	bg_panel.anchor_bottom = 1
	bg_panel.margin_right = 0
	bg_panel.margin_bottom = 0
	bg_panel.mouse_filter = MOUSE_FILTER_IGNORE
	bg_panel.show_behind_parent = true
	
	focus_panel = Panel.new()
	focus_panel.anchor_right = 1
	focus_panel.anchor_bottom = 1
	focus_panel.margin_right = 0
	focus_panel.margin_bottom = 0
	focus_panel.mouse_filter = MOUSE_FILTER_IGNORE
	focus_panel.show_behind_parent = true
	add_child(bg_panel)
	add_child(focus_panel)
	add_child(line_highlight)
	add_child(line_error)
	add_child(word_error)
	add_child(hover_timer)
	add_child(popup_panel)
	var con_err_str := "connect returned error '%s'"
	printiferr(
			self.connect("focus_entered", self, "_on_focus_changed", [true]), 
			con_err_str)
	printiferr(
			self.connect("focus_exited", self, "_on_focus_changed", [false]),
			con_err_str)
	printiferr(
			self.connect("mouse_entered", self, "_on_mouse_entered"),
			con_err_str)
	printiferr(
			self.connect("mouse_exited", self, "_on_mouse_exited"),
			con_err_str)
	printiferr(
			self.connect("cursor_changed", self, "_on_cursor_changed"),
			con_err_str)
	printiferr(
			self.connect("text_changed", self, "_on_text_changed"),
			con_err_str)
	printiferr(
			hover_timer.connect("timeout", self, "_on_hover_timeout"),
			con_err_str)

func printiferr(error: int, message: String):
	if error:
		printerr(message % error)

var has_readied := false
func _ready() -> void: 
	if not has_readied:
		has_readied = true
		print("ready func called")
		line_highlight.color = highlight_color
		line_error.color = error_color
		word_error.color = error_color
		if not normal_style:
			normal_style = get_stylebox("normal").duplicate(true)
			if has_color("background_color"):
				normal_style = StyleBoxFlat.new()
				normal_style.bg_color = get_color("background_color")
			focus_style = get_stylebox("focus").duplicate(true)
			readonly_style = get_stylebox("read_only").duplicate(true)
		if not readonly:
			bg_panel.add_stylebox_override("panel", normal_style)
		else:
			bg_panel.add_stylebox_override("panel", readonly_style)
		focus_panel.add_stylebox_override("panel", focus_style)
		focus_panel.visible = has_focus()
		# make the background elements of the textedit not appear
		# (so we fall back to the custom ones created above)
		add_stylebox_override("normal", StyleBoxEmpty.new())
		add_stylebox_override("focus", StyleBoxEmpty.new())
		add_stylebox_override("read_only", StyleBoxEmpty.new())
		add_color_override("background_color", Color(0.0, 0.0, 0.0, 0.0))


var old_v_scroll := scroll_vertical
var old_h_scroll := scroll_horizontal

var error_line := -1
var error_column := -1
var error_end_column := -1

var mouse_over := false
var clicked_this_frame := false

func _process(_delta: float) -> void:
	clicked_this_frame = false
	if old_h_scroll != scroll_horizontal or old_v_scroll != scroll_vertical:
		line_highlight.rect_position.y = get_local_pos_at(cursor_get_line(), 0).y
		line_error.rect_position.y = get_local_pos_at(error_line, 0).y
		word_error.rect_position = get_local_pos_at(error_line, error_column)
		old_h_scroll = scroll_horizontal
		old_v_scroll = scroll_vertical

func _on_mouse_entered() -> void:
	mouse_over = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var me := event as InputEventMouseButton
		if me.button_index == BUTTON_LEFT and me.pressed:
			clicked_this_frame = true
	if event is InputEventMouseMotion:
		var mpos = get_global_mouse_position()
		if (popup_panel.rect_position - mpos).length() > 10:
			if popup_panel.rect_position > mpos or popup_panel.rect_size < mpos - popup_panel.rect_position:
				popup_panel.hide()
		if mouse_over and not popup_panel.visible:
			hover_timer.start()
		else:
			hover_timer.stop()


func _on_mouse_exited() -> void:
	mouse_over = false

func set_background(bg_color: Color) -> void:
	print(bg_color)
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = bg_color
	if not readonly:
		bg_panel.add_stylebox_override("panel", normal_style)
	print(normal_style.to_string())
	

func _on_focus_changed(focused: bool):
	focus_panel.visible = focused

func _on_cursor_changed():
	line_highlight.rect_position.y = get_local_pos_at(cursor_get_line(), 0).y

func _on_text_changed():
	hover_timer.start()

func _on_hover_timeout():
	do_popup()

func _get_popup_text(_mouse_pos: Vector2) -> String:
	return ""

var word_characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"

func set_word_characters(chars: String) -> void:
	word_characters = chars

func is_word_character(s: String) -> bool:
	return s in word_characters

func pos_at_mouse():
	get_text_pos_at(get_local_mouse_position())

func get_row_height() -> float:
	var line_spacing = get("custom_constants/line_spacing")
	if not typeof(line_spacing) == TYPE_INT:
		line_spacing = get_constant("line_spacing", "TextEdit")
	return get_font("font").get_height() + line_spacing

func get_char_width(c: String):
	assert(c.length() == 1)
	if c == "\t":
		return get_font("font").get_char_size(" ".ord_at(0)).x * 4
	return get_font("font").get_char_size(c.ord_at(0)).x

func get_gutter_width() -> float:
	var width := 0.0
	if show_line_numbers:
		width += get_char_width('2') * (Lib.log_b(get_line_count() as float, 10.0) as int + 2.0)
	if breakpoint_gutter:
		width += 10.0
	if fold_gutter:
		width += 10.0
	return width

func get_local_pos_at(line_i: int, column: int, centered := false) -> Vector2:
	var line_height := get_row_height()
	var total_height := 0.0
	for check_line in range(0, line_i):
		if not is_line_hidden(check_line):
			total_height += line_height
	var line = get_line(line_i)
	var total_width := get_gutter_width()
	for c_idx in min(line.length(), column):
		if line[c_idx] == "\t":
			total_width += get_char_width(" ") * 4
		else:
			total_width += get_char_width(line[c_idx])
	
	if centered:
		total_height += line_height / 2.0
		if line.length() > column:
			total_width += get_char_width(line[column]) / 2.0
	
	return Vector2(total_width - scroll_horizontal, total_height - scroll_vertical * get_row_height() + 2.0)

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
	var local_mouse_x = p_mouse.x + scroll_horizontal
	for c_idx in line.length():
		var width = get_char_width(line[c_idx])
		if line[c_idx] == "\t":
			width = get_char_width(" ") * 4
		if total_width + width > local_mouse_x:
			if total_width + width / 2 > local_mouse_x:
				guessed_row = c_idx
			else:
				guessed_row = c_idx + 1
			break
		total_width += width
	if guessed_row == -1:
		guessed_row = line.length()
	guessed_row = min(guessed_row, get_line(guessed_line).length())
	return [guessed_line, guessed_row]


func hl_error(line: int, column: int, length: int):
	if line >= get_line_count() \
			or column >= get_line(line).length() \
			or (column + length) >= get_line(line).length() + 1:
		printerr("Tried setting error line outside of text bounds: (%d, %d(+%d))" % [line, column, length])
		return
	error_line = line
	error_column = column
	error_end_column = column + length
	line_error.visible = true
	word_error.visible = true
	
	var box_pos := get_local_pos_at(error_line, error_column)
	var end_box_pos = get_local_pos_at(error_line, error_end_column)
	line_error.rect_size = Vector2(line_error.rect_size.x, get_row_height())
	line_error.rect_position.y = box_pos.y
	word_error.rect_size = Vector2(end_box_pos.x - box_pos.x, get_row_height())
	word_error.rect_position = Vector2(box_pos.x, box_pos.y)

func clear_error():
	error_line = -1
	error_column = -1
	error_end_column = -1
	line_error.visible = false
	word_error.visible = false

func do_popup():
	var popup_text = _get_popup_text(get_local_mouse_position())
	if popup_text == "":
		return
	(popup_panel.get_child(0) as PopupTextEdit).set_popup_text(popup_text)
	popup_panel.popup()
	popup_panel.set_position(get_global_mouse_position() + Vector2(1, 1))
	pass
	
	
