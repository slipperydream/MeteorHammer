extends Control

@onready var score_counter = $TopBarLeft/ScoreLabel
@onready var multiplier_label = $TopBarRight/MultiplierLabel
@onready var lives_counter = $BottomBar/PlayerLivesLabel
@onready var credits_counter = $BottomBar/PlayerCreditsLabel
@onready var weapon_label = $BottomBar/MainWeapon
@onready var bomb_label = $BottomBar/Bomb

var num_lives = 0
var weapon : String = 'Beam'
var bomb : String = 'Bomb'

func _ready():
	$BossLabel.visible = false

func _process(_delta):
	pass
	
func update_score(value):
	var s = "%08d" % value
	score_counter.text = str(s)

func update_lives(value):
	num_lives += value
	if lives_counter:
		lives_counter.text = "x%s" % str(num_lives)
	
func update_credits(value):
	if credits_counter:
		credits_counter.text = "Credits: x%s" % str(value)
	
func _on_main_score_changed(score):
	update_score(score)
	
func _on_player_died():
	update_lives(-1)	

func _on_player_gained_life():
	update_lives(1)
	
func _on_player_out_of_lives():
	update_lives(0)

func _on_main_player_start(lives, credits):
	update_lives(lives)
	update_credits(credits)
	if credits <= 0:
		$Stopwatch.stop()

func _on_player_bomb_recharged():
	$AnimationPlayer.play("bomb_recharged")

func _on_player_bomb_used():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("bomb_used")

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

func _on_player_bomb_charging():
	$AnimationPlayer.play("bomb_charging")
