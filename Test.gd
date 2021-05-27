extends Node

func _ready() -> void:
	preload("res://gsl_tokenizer.gd").new()._ready()
	get_tree().quit()
#	print("res://some/random/path/with/file.withextension".get_base_dir())
	
	$TextEdit.text = $Sprite.material.shader.get_raw_code()
	update_text()

func update_text() -> void:
	$Sprite.material.shader.set_code($TextEdit.text)

	$TextEdit2.text = $Sprite.material.shader.get_code()
	$TextEdit2.cursor_set_line($TextEdit.cursor_get_line())
	$TextEdit2.cursor_set_column($TextEdit.cursor_get_column())
	$TextEdit.set_shader_mode($Sprite.material.shader.get_mode())
	$TextEdit2.set_shader_mode($Sprite.material.shader.get_mode())

func _on_TextEdit_text_changed() -> void:
	$Timer.start()

func _on_Timer_timeout() -> void:
	update_text()
