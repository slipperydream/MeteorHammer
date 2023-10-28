extends Control

signal ship_select_cancelled

@export var ships : Array[Ship_configuration] = []
var ship_index : int = 0
@export var special_weapons : Array[Texture2D]
var special_weapon_index : int = 0
@export var bomb_settings : Array[Bomb_setting] = []
var bomb_index : int = 0

@onready var selected_ship_img = $Panel/Ship/Control/Sprite2D
@onready var prev_ship = $ShipPreviousButton
@onready var next_ship = $ShipNextButton
@onready var ship_name = $ShipName
@onready var ship_speed = $Speed
@onready var ship_shot_width = $ShotWidth

@onready var selected_special_weapon_img = $SpecialWeapon/Control/Sprite2D
@onready var prev_special_weapon = $WeaponPreviousButton
@onready var next_special_weapon = $WeaponNextButton
@onready var special_weapon_label = $SpecialWeaponLabel

@onready var selected_bomb_setting = $BombSetting/Label
@onready var prev_bomb_setting = $BombSettingPreviousButton
@onready var next_bomb_setting = $BombSettingNextButton
@onready var starting_bombs = $StartingBombsCounter
@onready var max_bombs = $MaxBombsCounter
@onready var max_options = $MaxOptionsCounter

@onready var random_button = $GridContainer2/RandomizeButton
@onready var accept_button = $GridContainer2/AcceptButton


# Called when the node enters the scene tree for the first time.
func _ready():
	update_ship()
	update_special_weapon()
	update_bomb_settings()

func display_popup(text):
	$AcceptDialog.set_text(text)
	$AcceptDialog.popup_centered()

func update_ship():
	selected_ship_img.texture = ships[ship_index].sprite
	selected_ship_img.hframes = 3
	selected_ship_img.frame = 1
	ship_name.text = ships[ship_index].name
	
	ship_speed.value = ships[ship_index].speed
	ship_shot_width.value = ships[ship_index].shot_width

func update_special_weapon():
	#selected_special_weapon_img.texture = special_weapons[special_weapon_index].sprite
	pass

func update_bomb_settings():
	selected_bomb_setting.text = bomb_settings[bomb_index].setting_name
	starting_bombs.text = str(bomb_settings[bomb_index].starting_bombs)
	max_bombs.text = str(bomb_settings[bomb_index].max_bombs)
	max_options.text = str(bomb_settings[bomb_index].max_options)
	
func _on_settings_pressed():
	var text = "Sorry, the settings menu isn't implemented yet."
	display_popup(text)

func _on_shop_pressed():
	var text = "Sorry, the shop menu isn't implemented yet."
	display_popup(text)

func _on_ship_previous_button_pressed():
	ship_index -= 1
	if ship_index < 0:
		ship_index = ships.size() - 1
	update_ship()

func _on_ship_next_button_pressed():
	ship_index += 1
	if ship_index >= ships.size():
		ship_index = 0
	update_ship()

func _on_randomize_button_pressed():
	ship_index = randi() % ships.size()
	special_weapon_index = randi() % special_weapons.size()
	bomb_index = randi() % bomb_settings.size()
	update_ship()
	update_special_weapon()
	update_bomb_settings()

func _on_back_button_pressed():
	hide()
	emit_signal("ship_select_cancelled")

func _on_weapon_previous_button_pressed():
	special_weapon_index -= 1
	if special_weapon_index < 0:
		special_weapon_index = special_weapons.size() - 1
	update_special_weapon()

func _on_weapon_next_button_pressed():
	special_weapon_index += 1
	if special_weapon_index >= special_weapons.size():
		special_weapon_index = 0
	update_special_weapon()

func _on_bomb_setting_previous_button_pressed():
	bomb_index -= 1
	if bomb_index < 0:
		bomb_index = bomb_settings.size() - 1
	update_bomb_settings()

func _on_bomb_setting_next_button_pressed():
	bomb_index += 1
	if bomb_index >= bomb_settings.size():
		bomb_index = 0
	update_bomb_settings()
