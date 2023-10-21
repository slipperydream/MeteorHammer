extends Control

signal story_mode
signal attack_mode
signal stage_mode
signal boss_mode

@onready var story_mode_button = $Panel/MainMenu/StoryModeButton
@onready var attack_mode_button = $Panel/MainMenu/AttackModeButton
@onready var stage_select_button = $Panel/MainMenu/StageSelectButton
@onready var boss_select_button = $Panel/MainMenu/BossSelectButton
@onready var settings_button = $Panel/MainMenu/SettingsButton
@onready var high_scores_button = $Panel/MainMenu/HighScoresButton

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_everything()
	var tween = create_tween()
	tween.tween_property($Panel/Title, "position", Vector2(21.5, 84), 2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action("ui_accept"):
		$MenuTimer.stop()
		
func hide_everything():
	$Popup.hide()
	$StageSelect.hide()
	$Panel/MainMenu.hide()
	
func _on_story_mode_button_pressed():
	emit_signal("story_mode")

func _on_attack_mode_button_pressed():
	emit_signal("attack_mode")
	
func _on_stage_select_button_pressed():
	not_implemented()
	#$StageSelect.show()

func _on_boss_select_button_pressed():
	#not_implemented()
	emit_signal("boss_mode")

func _on_settings_button_pressed():
	not_implemented()

func _on_high_scores_button_pressed():
	not_implemented()

func _on_close_button_pressed():
	$Popup.hide()

func not_implemented():
	$Popup.show()

func _on_menu_timer_timeout():
	$Panel/MainMenu.show()
