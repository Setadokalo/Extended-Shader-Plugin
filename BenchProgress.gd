extends ProgressBar

func _on_BenchProgress_changed() -> void:
	$Label.text = "%d/%d (%d%%)" % [value, max_value, (value as float) / (max_value as float) * 100]


func _on_BenchProgress_value_changed(_new_value: float) -> void:
	$Label.text = "%d/%d (%d%%)" % [value, max_value, (value as float) / (max_value as float) * 100]
