extends Panel

signal stage_select_cancelled
signal stage_selected

const stage_button = preload("res://ui/stage_select/stage_button.tscn")
@export_dir var stages_dir

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var error_screen = $ErrorPanel

func _ready():
	error_screen.hide()
	get_stages(stages_dir)
	
func get_stages(path):
	var dir = DirAccess.open(path)
	if dir.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			create_stage_button('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		error_screen.ErrorLabel.text = "An error occurred trying to access the path %s" % path
		error_screen.show()
	
func create_stage_button(stage_path, stage_name):
	var btn = stage_button.instantiate()
	btn.text = stage_name.trim_suffix('.tscn').replace("_", " ")
	btn.stage_path = stage_path
	grid.add_child(btn)
	btn.connect("stage_selected", _on_stage_selected)

func _on_stage_selected(stage):
	emit_signal("stage_selected", stage)
	hide()

func _on_back_button_pressed():
	hide()
	emit_signal("stage_select_cancelled")

func _on_error_close_button_pressed():
	error_screen.hide()
