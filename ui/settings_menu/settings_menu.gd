extends Control

class_name SettingsMenu

signal settings_closed

@onready var changed_settings = {}
@onready var master_sound = AudioServer.get_bus_index("Master")
@onready var music_sound = AudioServer.get_bus_index("Music")
@onready var sound_effects = AudioServer.get_bus_index("SFX")

func _ready():
	SettingsManager.connect("settings_reverted", _on_settings_reverted)

func _on_default_button_pressed():
	print(changed_settings)
	var text = "Revert to default settings?"
	$ConfirmationDialog.set_text(text)
	$ConfirmationDialog.set_ok_button_text("Yes")
	$ConfirmationDialog.popup_centered()
	
func _on_confirmation_dialog_confirmed():
	SettingsManager.revert_settings()

func _on_settings_reverted():
	for child in get_children():
		if child.has_method("configure"):
			child.configure()

func _on_close_button_pressed():
	emit_signal("settings_closed")
	hide()

