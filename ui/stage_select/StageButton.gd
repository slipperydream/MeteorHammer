extends Button

@export_file var stage_path : String
signal stage_selected

func _on_pressed():
	if stage_path == null:
		return
	emit_signal('stage_selected', stage_path)

func _on_mouse_entered():
	pass # Replace with function body.
