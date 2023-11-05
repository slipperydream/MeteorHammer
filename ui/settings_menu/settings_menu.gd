extends Control

class_name SettingsMenu

signal cancel_settings_change
signal settings_changed

@onready var settings = SettingsManager.get_settings()
@onready var changed_settings = {}

func _ready():
	# update without sending signals
	$AutobombSetting/CheckBox.set_pressed_no_signal(settings["gameplay"]["autobomb"])

func _on_check_box_toggled(button_pressed):
	changed_settings["autobomb"] = settings["gameplay"]["autobomb"]
	settings["gameplay"]["autobomb"] = button_pressed

func _on_cancel_button_pressed():
	emit_signal("cancel_settings_change")
	hide()


func _on_accept_button_pressed():
	print(changed_settings)
	var text = "Accept changes to settings?"
	$ConfirmationDialog.set_text(text)
	$ConfirmationDialog.set_ok_button_text("Yes")
	$ConfirmationDialog.popup_centered()
	
func _on_confirmation_dialog_confirmed():
	emit_signal("settings_changed")
	hide()

