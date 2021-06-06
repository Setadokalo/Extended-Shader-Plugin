extends Control



func _on_TextEditTest_pressed() -> void:
	if get_tree().change_scene("res://Test.tscn"):
		printerr("failed to change scene")


func _on_TokenParseTest_pressed() -> void:
	if get_tree().change_scene("res://TokenTest.tscn"):
		printerr("failed to change scene")
