extends HBoxContainer

class_name AudioControl

signal audio_bus_volume_changed
signal audio_bus_muted

@export var audio_bus_name : String = "Master"

# Called when the node enters the scene tree for the first time.
func _ready():
	configure()

func _on_volume_switch_toggled(button_pressed):
	mute_sound(button_pressed)

func _on_h_slider_value_changed(value):
	change_volume(value)
	
func change_volume(value):
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	emit_signal("audio_bus_volume_changed", audio_bus_name, value)
	SettingsManager.set_audio_bus_volume(audio_bus_name,  linear_to_db(value))
	
func configure():
	$AudioBusLabel.text = audio_bus_name
	$Volume.set_value_no_signal(db_to_linear(SettingsManager.get_audio_bus_volume(audio_bus_name)))
	change_volume($Volume.value)
	$VolumeToggle.set_pressed_no_signal(SettingsManager.get_audio_bus_muted(audio_bus_name))
	mute_sound($VolumeToggle.button_pressed)

func mute_sound(value):
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	AudioServer.set_bus_mute(bus_index, value)
	emit_signal("audio_bus_muted", audio_bus_name, value)
	SettingsManager.set_audio_bus_muted(audio_bus_name, value)
