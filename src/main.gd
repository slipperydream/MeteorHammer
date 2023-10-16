extends Node2D

@onready var start_button = $CanvasLayer/CenterContainer/StartButton
@onready var pause_button = $CanvasLayer/CenterContainer/PauseButton
@onready var game_over_label = $CanvasLayer/CenterContainer/GameOver
@onready var stage_label = $CanvasLayer/CenterContainer/StageLabel
@onready var screensize : Vector2 = get_viewport_rect().size

enum game_state {ATTRACT, NEW_GAME, RUNNING, PAUSED, GAME_OVER}
enum spawn_pattern {WALL, DIAGONAL_LEFT, DIAGONAL_RIGHT, TRIANGLE, SQUARE, CIRCLE, BOSS}
#enum spawn_pattern {WALL, LINE, LEFT_WALL, RIGHT_WALL, STAGGERED, DIAGONAL_LEFT, DIAGONAL_RIGHT, BOSS}


signal new_game
signal start_game
signal game_over
signal game_unpaused
signal pause_game
signal score_changed
signal stage_cleared

var enemy1 = preload(""res://scenes/enemies/base_enemy.tscn"")
var score = 0
var current_game_state : game_state = game_state.ATTRACT
var stage : int = 1
var enemy_alive = false
@export var columns : int = 9
@export var rows : int = 3
@export var start_lives = 3
@export var waves_per_stage : int = 3

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
	current_game_state = game_state.RUNNING
	stage = 1
	show_stage_label()
	spawn_stage_waves(stage)

func spawn_stage_waves(stage):
	var num_waves = stage * waves_per_stage
	for i in range(num_waves):
		var pattern = randi() % spawn_pattern.size()
		var num_mobs = columns
		spawn_enemies(num_mobs, pattern)
		print("Spawned wave %d " % num_waves)
		print("mobs %d" % num_mobs)
		print("pattern %d" % pattern)
		await get_tree().create_timer(20).timeout

func show_stage_label():
	stage_label.text = "STAGE %d" % stage
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
		var e = enemy.instantiate()
		var pos = Vector2(x * left_buffer + 24, -16)
		add_child(e)
		e.start(pos)
		e.died.connect(_on_enemy_died)

func spawn_enemies_diagonal(isLeft, num_mobs = columns):
	var left_buffer = screensize.x / num_mobs
	for x in range(num_mobs):
		var e = enemy.instantiate()
		var y =  (num_mobs-x) * -16
		if isLeft:
			y = -x * 16
				
		var pos = Vector2(x * left_buffer + 24, y)
		add_child(e)
		e.start(pos)
		e.died.connect(_on_enemy_died)

func spawn_boss():
	var e = enemy.instantiate()
	var pos = Vector2(screensize.x/2, 16)
	add_child(e)
	e.start(pos)
	e.died.connect(_on_enemy_died)
	
func _on_enemy_died(value):
	score += value
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
	if get_tree().get_nodes_in_group("enemies").is_empty():
		enemy_alive = false
		print("cleared stage %d" % stage)
		emit_signal("stage_cleared")

func _on_stage_cleared():
	stage += 1
	show_stage_label()
	spawn_stage_waves(stage)

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

