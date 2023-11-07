extends Panel

signal stage_select_cancelled
signal stage_selected
signal settings_menu

const stage_button = preload("res://ui/stage_select/stage_button.tscn")
@export_dir var stages_dir

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready():
	get_stages(stages_dir)
	
func get_stages(path):
	var dir = DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			create_stage_button('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		var text = "An error occurred trying to access the path %s" % path
		display_popup(text)
	sort_stages()
	
func create_stage_button(stage_path, stage_name):
	if stage_name.get_extension() == 'tscn':
		var btn = stage_button.instantiate()
		btn.text = stage_name.trim_suffix('.tscn').replace("_", " ")
		btn.stage_path = stage_path
		grid.add_child(btn)
		btn.connect("stage_selected", _on_stage_selected)

func display_popup(text):
	$AcceptDialog.set_text(text)
	$AcceptDialog.popup_centered()

func sort_stages():
	if grid.get_child_count() <= 0:
		return
	var sorted_buttons = grid.get_children()
	sorted_buttons.sort_custom(
		func(a: StageButton, b: StageButton): return a.text.naturalnocasecmp_to(b.name) < 0
	)

	var i : int = 0
	for node in sorted_buttons:
		grid.move_child(node, i)
		i += 1
	
			
func _on_stage_selected(stage):
	emit_signal("stage_selected", stage)
	hide()

func _on_back_button_pressed():
	hide()
	emit_signal("stage_select_cancelled")


func _on_settings_pressed():
	emit_signal("settings_menu")
	hide()

