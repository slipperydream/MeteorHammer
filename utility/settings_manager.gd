extends Node

const SETTINGS_FILE_PATH = "res://settings.cfg"

var config = ConfigFile.new()

var settings = {
	"audio" : {
		"master_volume": 0,
		"music_volume": 0,
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
	#save_settings()
	load_settings()
	
func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
			
	config.save(SETTINGS_FILE_PATH)
	
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
	
func get_master_volume():
	return settings["audio"]["master_volume"]
	
func get_music_volume():
	return settings["audio"]["music_volume"]
	
func get_autobomb():
	return settings["gameplay"]["autobomb"]

func get_bullet_color():
	return settings["visual"]["bullet_color"]
