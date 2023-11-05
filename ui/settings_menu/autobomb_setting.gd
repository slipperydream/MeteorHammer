extends HBoxContainer

signal autobomb_enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	configure()

func configure():
	$CheckBox.set_pressed_no_signal(SettingsManager.get_autobomb())

func _on_check_box_toggled(button_pressed):
	emit_signal("autobomb_enabled", button_pressed)
	SettingsManager.set_autobomb(button_pressed)
