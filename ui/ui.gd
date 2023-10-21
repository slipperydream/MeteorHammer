extends Control

@onready var score_counter = $TopBarLeft/ScoreLabel
@onready var lives_counter = $BottomBar/PlayerLivesLabel
@onready var weapon_label = $BottomBar/Weapon
@onready var item_label = $BottomBar/Item

var num_lives = 0
var weapon : String = 'Beam'
var item : String = 'Bomb'

func _ready():
	$BossLabel.visible = false

func _process(delta):
	pass
	
func update_score(value):
	var s = "%08d" % value
	score_counter.text = str(s)

func update_lives(value):
	num_lives += value
	if lives_counter:
		lives_counter.text = "x%s" % str(num_lives)
	
func _on_main_score_changed(score):
	update_score(score)
	
func _on_player_died():
	update_lives(-1)	

func _on_player_gained_life():
	update_lives(1)
	
func _on_player_out_of_lives():
	update_lives(0)
	$Stopwatch.reset()
	
func _on_main_start_game(lives, _stage):
	$TopBarLeft.show()
	$BottomBar.show()
	update_lives(lives)

func _on_player_item_recharged():
	$AnimationPlayer.play("item_recharged")

func _on_player_item_changed(new_item):
	item_label.text = new_item

func _on_player_item_used():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("item_used")

func _on_player_weapon_changed(new_weapon):
	if weapon_label:
		weapon_label.text = new_weapon

func _on_player_item_charging():
	$AnimationPlayer.play("item_charging")

func _on_boss_spawned():
	$AnimationPlayer.play("boss_warning")

func _on_main_stage_cleared(_stage):
	$Stopwatch.stop()
	var time_spent = $Stopwatch.time_elapsed

func _on_main_new_stage(_stage):
	$Stopwatch.reset()
	$Stopwatch.start()

func _on_main_pause_game():
	$Stopwatch.pause(true)

func _on_center_container_game_unpaused():
	$Stopwatch.pause(false)
