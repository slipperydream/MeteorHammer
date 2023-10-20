extends Node2D

@onready var screensize : Vector2 = get_viewport_rect().size

enum game_state {ATTRACT, NEW_GAME, RUNNING, PAUSED, GAME_OVER}

signal new_game
signal start_game
signal game_over
signal pause_game
signal score_changed
signal stage_cleared
signal new_stage

var score = 0
var current_game_state : game_state = game_state.ATTRACT
var current_stage : int = 0
var boss_spawned = false
var scoring_chain_active : bool = false
var scoring_multiplier : int = 1


@export var start_lives = 3
@export var scoring_timer : int = 5
@export var max_scoring_multiplier : int = 30
var stages : Array = ["res://stages/Stage_1.tscn", "res://stages/Stage_2.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_game_state = game_state.NEW_GAME
	emit_signal("new_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_game_state == game_state.RUNNING and boss_spawned:
		check_for_stage_clear()

func begin_game():
	score = 0
	emit_signal("score_changed", score)
	current_stage = 0
	emit_signal("start_game", start_lives, current_stage)
	current_game_state = game_state.RUNNING
	load_stage(current_stage)

func check_for_stage_clear():
	if get_tree().get_nodes_in_group("boss").is_empty():
		boss_spawned = false
		emit_signal("stage_cleared", current_stage)
		
func load_stage(num):
	var last_stage = get_tree().get_first_node_in_group("stage")
	if last_stage:
		last_stage.queue_free()
	var stage = load(stages[num])
	var stage_instance = stage.instantiate()
	add_child(stage_instance)
	stage_instance.start()
	emit_signal("new_stage", num)
	
func _input(event):
	if Input.is_action_just_pressed("pause_game"):
		current_game_state = game_state.PAUSED
		emit_signal("pause_game")
	
func _on_enemy_died(value):
	if scoring_chain_active:
		scoring_multiplier += 1
		if scoring_multiplier > max_scoring_multiplier:
			scoring_multiplier = max_scoring_multiplier;
	else:
		scoring_multiplier = 1
		$ScoringTimer.wait_time = scoring_timer
		$ScoringTimer.start()
		scoring_chain_active = true
	#print("scoring multiplier %f" %scoring_multiplier)
	score += value * scoring_multiplier	
	emit_signal("score_changed", score)

func _on_player_died():
	current_game_state = game_state.PAUSED
	pause_game.emit()

func _on_player_out_of_lives():
	get_tree().call_group("enemies", "queue_free")
	current_game_state = game_state.GAME_OVER
	emit_signal("game_over")

func _on_stage_cleared(_stage):
	if current_stage + 1 >= stages.size():
		print("You beat the game")
		emit_signal("game_over")
	else:
		current_stage += 1
		load_stage(current_stage)

func _on_pause_game():
	get_tree().paused = true

func _on_game_over():
	get_tree().call_group("stages", "queue_free")
	await get_tree().create_timer(2).timeout
	current_game_state = game_state.NEW_GAME
	emit_signal("new_game")

func _on_scoring_timer_timeout():
	scoring_chain_active = false
	scoring_multiplier = 1

func _on_boss_spawned():
	boss_spawned = true
	$Background.stop()
	
func _on_center_container_game_unpaused():
	current_game_state = game_state.RUNNING
	get_tree().paused = false

func _on_center_container_start_pressed():
	begin_game()
