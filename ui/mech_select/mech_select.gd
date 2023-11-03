extends Control

signal mech_select_cancelled
signal mech_selected

@export var mechs : Array[Mech_configuration] = []
var mech_index : int = 0
@export var special_weapons : Array[Special_weapon]
var special_weapon_index : int = 0
@export var bomb_settings : Array[Bomb_setting] = []
var bomb_index : int = 0

@onready var selected_mech_img = $Panel/Mech/Control/Sprite2D
@onready var prev_mech = $MechPreviousButton
@onready var next_mech = $MechNextButton
@onready var mech_name = $MechName
@onready var mech_speed = $Speed
@onready var mech_shot_width = $ShotWidth
@onready var mech_laser_power = $LaserPower

@onready var selected_special_weapon_img = $SpecialWeapon/Control/Sprite2D
@onready var prev_special_weapon = $WeaponPreviousButton
@onready var next_special_weapon = $WeaponNextButton
@onready var special_name = $SpecialWeaponName
@onready var special_description = $SpecialWeaponDescription
@onready var special_weapon_label = $SpecialWeaponLabel

@onready var selected_bomb_setting = $BombSetting/Label
@onready var prev_bomb_setting = $BombSettingPreviousButton
@onready var next_bomb_setting = $BombSettingNextButton
@onready var recharge  = $RechargeTimeCounter
@onready var max_options = $MaxOptionsCounter

@onready var random_button = $GridContainer2/RandomizeButton
@onready var accept_button = $GridContainer2/AcceptButton


# Called when the node enters the scene tree for the first time.
func _ready():
	update_mech()
	update_special_weapon()
	update_bomb_settings()

func display_popup(text):
	$AcceptDialog.set_text(text)
	$AcceptDialog.popup_centered()

func update_mech():
	selected_mech_img.texture = mechs[mech_index].sprite
	selected_mech_img.hframes = 3
	selected_mech_img.frame = 0
	mech_name.text = mechs[mech_index].name
	
	mech_speed.value = mechs[mech_index].speed
	mech_shot_width.value = mechs[mech_index].shot_width
	mech_laser_power.value = mechs[mech_index].laser_power

func update_special_weapon():
	if special_weapons[special_weapon_index].name.to_lower().contains("katana"):
		selected_special_weapon_img.hframes = 1
		selected_special_weapon_img.frame = 0
	elif special_weapons[special_weapon_index].name.to_lower().contains("mine"):
		selected_special_weapon_img.hframes = 4
		selected_special_weapon_img.frame = 0
	elif special_weapons[special_weapon_index].name.to_lower().contains("missile"):
		selected_special_weapon_img.hframes = 16
		selected_special_weapon_img.frame = 0
	
	special_name.text = special_weapons[special_weapon_index].name
	selected_special_weapon_img.texture = special_weapons[special_weapon_index].sprite
	special_description.text = special_weapons[special_weapon_index].description

func update_bomb_settings():
	selected_bomb_setting.text = bomb_settings[bomb_index].setting_name
	recharge.text = str(bomb_settings[bomb_index].recharge_time)
	max_options.text = str(bomb_settings[bomb_index].max_options)
	
func _on_settings_pressed():
	var text = "Sorry, the settings menu isn't implemented yet."
	display_popup(text)

func _on_mech_previous_button_pressed():
	mech_index -= 1
	if mech_index < 0:
		mech_index = mechs.size() - 1
	update_mech()

func _on_mech_next_button_pressed():
	mech_index += 1
	if mech_index >= mechs.size():
		mech_index = 0
	update_mech()

func _on_randomize_button_pressed():
	mech_index = randi() % mechs.size()
	special_weapon_index = randi() % special_weapons.size()
	bomb_index = randi() % bomb_settings.size()
	update_mech()
	update_special_weapon()
	update_bomb_settings()

func _on_back_button_pressed():
	hide()
	emit_signal("mech_select_cancelled")

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

func _on_accept_button_pressed():
	emit_signal("mech_selected", mechs[mech_index], special_weapons[special_weapon_index], bomb_settings[bomb_index])
	hide()
