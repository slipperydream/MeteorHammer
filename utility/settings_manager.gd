extends Node

signal settings_reverted

const SETTINGS_FILE_PATH = "res://settings.cfg"

var config = ConfigFile.new()

var settings = {
	"audio" : {
		"master_muted": false,
		"master_volume": 0,
		"music_muted": false,
		"music_volume": 0,
		"sfx_muted": false,
		"sfx_volume": 0,
	},
	"gameplay": {
		"autobomb": true,
		"skip_intro": false,
		"skip_cutscenes": false,
		"boss_healthbars": true,
		"display_rank": false,
	},
	"input": {
		"main_fire": KEY_SPACE
	},
	"visual": {
		"show_hitboxes": true,
		"bullet_color": Color(0.39, 0.78, 0.3, 1),
		"display_mode": "FULLSCREEN",
		"resolution": "1920x1080",
		"aspect_ration": "DISPLAY",
		"v_sync": true,
		"left_panel_art": "girl",
		"right_panel_art": "girl",
	}
}

func _ready():
	#revert_settings()
	load_settings()
	print(settings)
	
func revert_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
			
	config.save(SETTINGS_FILE_PATH)
	emit_signal("settings_reverted")
	
func load_settings():
	var error = config.load(SETTINGS_FILE_PATH)
	if error != OK:
		print("Error loading settings file. %s" % error)
		return []
		
	for section in settings.keys():
		for key in settings[section].keys():
			settings[section][key] = config.get_value(section, key, null)

func get_settings():
	return settings
	
func get_audio_bus_muted(bus):
	var audio_bus = "%s_muted" % bus.to_lower()
	return settings["audio"][audio_bus]

func set_audio_bus_muted(bus, value):
	var key = "%s_muted" % bus.to_lower()
	config.set_value("audio", key, value)
	save()
		
func get_audio_bus_volume(bus):
	var audio_bus = "%s_volume" % bus.to_lower()
	return settings["audio"][audio_bus]
	
func set_audio_bus_volume(bus, value):
	var key = "%s_volume" % bus.to_lower()
	config.set_value("audio", key, value)
	save()
	
func get_autobomb():
	return settings["gameplay"]["autobomb"]
	
func set_autobomb(value):
	config.set_value("gameplay", "autobomb", value)
	save()

func get_bullet_color():
	return settings["visual"]["bullet_color"]

func set_bullet_color(color):
	config.set_value("visual", "bullet_color", color)
	save()

func save():
	config.save(SETTINGS_FILE_PATH)

	
