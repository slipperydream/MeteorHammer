extends Node2D

@onready var start_button = $CanvasLayer/CenterContainer/StartButton
@onready var pause_button = $CanvasLayer/CenterContainer/PauseButton
@onready var game_over_label = $CanvasLayer/CenterContainer/GameOver
@onready var stage_label = $CanvasLayer/CenterContainer/StageLabel
@onready var screensize : Vector2 = get_viewport_rect().size

enum game_state {ATTRACT, NEW_GAME, RUNNING, PAUSED, GAME_OVER}
enum spawn_pattern {WALL, DIAGONAL_LEFT, DIAGONAL_RIGHT, TRIANGLE, TRAPEZOID, CIRCLE, BOSS}


signal new_game
signal start_game
signal game_over
signal game_unpaused
signal pause_game
signal score_changed
signal stage_cleared

var enemy0 = preload("res://scenes/enemies/scout.tscn")
var enemy1 = preload("res://scenes/enemies/battlecruiser.tscn")
var enemy2 = preload("res://scenes/enemies/fighter.tscn")

var enemies : Array = [enemy0, enemy1, enemy2]
var score = 0
var current_game_state : game_state = game_state.ATTRACT
var current_stage : int = 1
var enemy_alive = false
var wave : int = 0
var scoring_chain_active : bool = false
var scoring_multiplier : float = 1.0
@export var columns : int = 9
@export var rows : int = 3
@export var start_lives = 3
@export var waves_per_stage : int = 3
@export var scoring_timer : int = 15
@export var max_scoring_multiplier : float = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	current_game_state = game_state.NEW_GAME
	emit_signal("new_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_game_state == game_state.RUNNING and enemy_alive:
		check_for_stage_clear()

func begin_game():
	score = 0
	emit_signal("score_changed", score)
	emit_signal("start_game", start_lives)
	current_stage = 1
	show_stage_label()
	wave = 0
	spawn_stage_wave()
	current_game_state = game_state.RUNNING

func spawn_stage_wave():	
	wave += 1
	var pattern = randi() % spawn_pattern.size()
	var num_mobs = columns / 4
	spawn_enemies(num_mobs, pattern)
	#print_spawned_wave(num_mobs, pattern)
	$WaveTimer.start()

func print_spawned_wave(num_mobs, pattern):
	print("Spawned wave %d " % wave)
	print("mobs %d" % num_mobs)
	print("pattern %d" % pattern)	

func show_stage_label():
	stage_label.text = "STAGE %d" % current_stage
	stage_label.show()
	await get_tree().create_timer(2).timeout
	stage_label.hide()
		
func _input(event):
	if Input.is_action_just_pressed("pause_game"):
		current_game_state = game_state.PAUSED
		emit_signal("pause_game")
		
func spawn_enemies(num_mobs, pattern):
	match pattern:
		spawn_pattern.WALL:
			spawn_enemies_wall(num_mobs)
		spawn_pattern.BOSS:
			spawn_boss()
		spawn_pattern.DIAGONAL_LEFT:
			spawn_enemies_diagonal(true, num_mobs)
		spawn_pattern.DIAGONAL_RIGHT:
			spawn_enemies_diagonal(false, num_mobs)
	enemy_alive = true
	
func spawn_enemies_wall(num_mobs = columns):
	var left_buffer = screensize.x / num_mobs
	for x in range(num_mobs):
		var e = enemies[randi() % enemies.size()].instantiate()
		var pos = Vector2(x * left_buffer + 24, -16)
		add_child(e)
		e.start(pos)
		e.died.connect(_on_enemy_died)

func spawn_enemies_diagonal(isLeft, num_mobs = columns):
	var left_buffer = screensize.x / num_mobs
	for x in range(num_mobs):
		var e = enemies[randi() % enemies.size()].instantiate()
		var y =  (num_mobs-x) * -16
		if isLeft:
			y = -x * 16
				
		var pos = Vector2(x * left_buffer + 24, y)
		add_child(e)
		e.start(pos)
		e.died.connect(_on_enemy_died)

func spawn_boss():
	var e = enemies[randi() % enemies.size()].instantiate()
	var pos = Vector2(screensize.x/2, 16)
	add_child(e)
	e.start(pos)
	e.died.connect(_on_enemy_died)
	
func _on_enemy_died(value):
	if scoring_chain_active:
		scoring_multiplier *= 1.5
		scoring_multiplier = max(scoring_multiplier, max_scoring_multiplier)
	else:
		scoring_multiplier = 1
		$ScoringTimer.wait_time = scoring_timer
		$ScoringTimer.start()
		scoring_chain_active = true
	print("scoring multiplier %f" %scoring_multiplier)
	score += value * scoring_multiplier	
	emit_signal("score_changed", score)

func _on_player_died():
	current_game_state = game_state.PAUSED
	pause_game.emit()

func _on_player_out_of_lives():
	get_tree().call_group("enemies", "queue_free")
	current_game_state = game_state.GAME_OVER
	emit_signal("game_over")

func _on_start_pressed():
	start_button.hide()
	begin_game()
	
func _on_pause_button_pressed():
	pause_button.hide()
	current_game_state = game_state.RUNNING
	emit_signal("game_unpaused")
	get_tree().paused = false

func check_for_stage_clear():
	if wave == (current_stage * waves_per_stage) and get_tree().get_nodes_in_group("enemies").is_empty() :
		enemy_alive = false
		emit_signal("stage_cleared", current_stage)

func _on_stage_cleared(_stage):
	current_stage += 1
	wave = 0
	show_stage_label()
	spawn_stage_wave()

func _on_pause_game():
	if game_over_label.visible:
		game_over_label.hide()
	if start_button.visible:
		start_button.hide()
	if pause_button.visible == false:
		pause_button.show()
	get_tree().paused = true

func _on_game_over():
	game_over_label.show()
	await get_tree().create_timer(2).timeout
	game_over_label.hide()
	current_game_state = game_state.NEW_GAME
	emit_signal("new_game")

func _on_new_game():
	if game_over_label.visible:
		game_over_label.hide()
	if pause_button.visible:
		pause_button.hide()
	start_button.show()

func _on_wave_timer_timeout():
	if wave < (current_stage * waves_per_stage):
		spawn_stage_wave()

func _on_scoring_timer_timeout():
	scoring_chain_active = false
	scoring_multiplier = 1
