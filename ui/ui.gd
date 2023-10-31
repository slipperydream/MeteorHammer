extends Control

@onready var score_counter = $TopBarLeft/ScoreLabel
@onready var multiplier_label = $TopBarRight/MultiplierLabel
@onready var lives_counter = $BottomBar/PlayerLivesLabel
@onready var continues = $TopBarLeft/Continues
@onready var weapon_label = $BottomBar/SpecialWeapon
@onready var bomb_label = $BottomBar/Bomb

var num_lives = 0
var bomb : String = 'Bomb'

func _ready():
	$BossLabel.visible = false
	
func update_score(value):
	var s = "%08d" % value
	score_counter.text = str(s)

func update_lives(value):
	num_lives += value
	if lives_counter:
		lives_counter.text = "x%s" % str(num_lives)
	
func update_continues(value):
	if value:
		continues.text = "Yes"
	else:
		continues.text = "No"
	
func _on_main_score_changed(score):
	update_score(score)
	
func _on_player_died():
	update_lives(-1)

func _on_player_gained_life():
	update_lives(1)
	
func _on_player_out_of_lives():
	update_continues(false)

func _on_main_player_lives(lives):
	update_lives(lives)

func _on_main_continue_earned():
	update_continues(true)
	
func _on_player_bomb_used():
	var tween = create_tween()
	tween.tween_property($BottomBar/Bomb/Panel, "scale:x", 1, 0.1)
	tween = create_tween()
	tween.tween_property($BottomBar/Bomb.get_theme_stylebox("normal"), "border_color", Color(0.45, 0.24, 0.22, 1), 0.1)

func _on_player_weapon_changed(new_weapon):
	if weapon_label:
		weapon_label.text = new_weapon

func _on_boss_spawned():
	$AnimationPlayer.play("boss_warning")
	await $AnimationPlayer.animation_finished
	$BossLabel.visible = false

func _on_main_new_stage(_stage):
	$TopBarLeft.show()
	$BottomBar.show()
	$Stopwatch.reset()
	$Stopwatch.start()

func _on_main_pause_game():
	$Stopwatch.pause(true)

func _on_center_container_game_unpaused():
	$Stopwatch.pause(false)

func _on_main_score_multiplier(multiplier):
	if multiplier > 1:
		multiplier_label.show()
		multiplier_label.text = "MULTIPLIER\nx%d" % multiplier
	else:
		multiplier_label.hide()

func _on_main_end_stage(_current, _results):
	$Stopwatch.stop()
	#var time_spent = $Stopwatch.time_elapsed
	hide()

func _on_player_bomb_charging(time):
	var tween = create_tween()
	tween.tween_property($BottomBar/Bomb/Panel, "scale:x", 0, time)
	tween = create_tween()
	tween.tween_property($BottomBar/Bomb.get_theme_stylebox("normal"), "border_color",  Color(0.39, 0.78, 0.3, 1), time)

	
	
