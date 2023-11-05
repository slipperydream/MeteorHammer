extends Control

signal start_game
signal attack_mode
signal boss_mode
signal exit_game
signal settings_menu

@onready var title_menu = $Panel/TitleMenu
@onready var start_game_button = $Panel/TitleMenu/StartGameButton
@onready var attack_mode_button = $Panel/TitleMenu/AttackModeButton
@onready var boss_select_button = $Panel/TitleMenu/BossSelectButton
@onready var settings_button = $Panel/TitleMenu/SettingsButton
@onready var high_scores_button = $Panel/TitleMenu/HighScoresButton
@onready var exit_game_button = $Panel/TitleMenu/ExitGameButton
@onready var screensize : Vector2 = get_viewport_rect().size
@onready var background = $Panel/Background
@onready var main = get_tree().get_first_node_in_group("main")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_everything()
	set_deferred("background.size.x", screensize.x)
	set_deferred("background.size.y", screensize.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(_event):
	if $MenuTimer.is_stopped() and Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel"):
		# real hacky way to get around timer not triggering timeout when stopped
		$MenuTimer.wait_time = 0.1
		$MenuTimer.start()
	if Input.is_action_just_pressed("ui_down"):
		var control = get_viewport().gui_get_focus_owner()
		if control:
			control.get_focus_neighbor(SIDE_BOTTOM)
		else:
			exit_game_button.grab_focus()
	elif Input.is_action_just_pressed("ui_up"):
		var control = get_viewport().gui_get_focus_owner()
		if control:
			control.get_focus_neighbor(SIDE_TOP)
		else:
			attack_mode_button.grab_focus()

		
func hide_everything():
	title_menu.hide()

func display_popup(text):
	$AcceptDialog.set_text(text)
	$AcceptDialog.popup_centered()
	
func _on_start_game_button_pressed():
	emit_signal("start_game")
	hide()

func _on_attack_mode_button_pressed():
	emit_signal("attack_mode")
	hide()

func _on_boss_select_button_pressed():
	emit_signal("boss_mode")
	hide()

func _on_settings_button_pressed():
	emit_signal("settings_menu")

func _on_high_scores_button_pressed():
	var text = "Sorry, the high scores menu isn't implemented yet."
	display_popup(text)

func _on_menu_timer_timeout():
	title_menu.show()


func _on_main_game_over():
	await get_tree().create_timer(5).timeout
	show()

func _on_exit_game_button_pressed():
	var text = "Are you sure you want to exit the game?"
	$ConfirmationDialog.set_text(text)
	$ConfirmationDialog.set_ok_button_text("Exit Game")
	$ConfirmationDialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	emit_signal("exit_game")

