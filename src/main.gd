extends Node2D

@onready var start_button = $CanvasLayer/CenterContainer/StartButton
@onready var pause_button = $CanvasLayer/CenterContainer/PauseButton
@onready var game_over = $CanvasLayer/CenterContainer/GameOver
@onready var stage_label = $CanvasLayer/CenterContainer/StageLabel

enum game_state {ATTRACT, NEW_GAME, RUNNING, PAUSED, GAME_OVER}
signal game_state_changed
signal pause_game
signal score_changed
signal stage_cleared

var enemy = preload("res://scenes/enemy.tscn")
var score = 0
var current_game_state : game_state = game_state.ATTRACT
var stage : int = 1
var enemy_alive = false
@export var columns : int = 9
@export var rows : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	current_game_state = game_state.NEW_GAME
	emit_signal("game_state_changed", current_game_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_game_state == game_state.RUNNING and enemy_alive:
		check_for_stage_clear()

func new_game():
	score = 0
	emit_signal("score_changed", score)
	current_game_state = game_state.RUNNING
	emit_signal("game_state_changed", current_game_state)
	stage = 1
	show_stage_label()
	spawn_enemies()

func show_stage_label():
	stage_label.text = "STAGE %d" % stage
	stage_label.show()
	await get_tree().create_timer(2).timeout
	stage_label.hide()
		
func _input(event):
	if Input.is_action_just_pressed("pause_game"):
		current_game_state = game_state.PAUSED
		emit_signal("game_state_changed", current_game_state)
		
func spawn_enemies():
	for x in range(columns):
		for y in range(rows):
			var e = enemy.instantiate()
			var pos = Vector2(x * 24 + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.died.connect(_on_enemy_died)
	enemy_alive = true

func _on_enemy_died(value):
	score += value
	emit_signal("score_changed", score)

func _on_start_pressed():
	start_button.hide()
	new_game()

func _on_player_died():
	current_game_state = game_state.PAUSED
	emit_signal("game_state_changed", current_game_state)

func _on_player_out_of_lives():
	get_tree().call_group("enemies", "queue_free")
	current_game_state = game_state.GAME_OVER
	emit_signal("game_state_changed", current_game_state)
	
func _on_pause_button_pressed():
	pause_button.hide()
	current_game_state = game_state.RUNNING
	emit_signal("game_state_changed", current_game_state)
	
func _on_game_state_changed(state):
	match state:
		game_state.PAUSED:
			if game_over.visible:
				game_over.hide()
			if start_button.visible:
				start_button.hide()
			if pause_button.visible == false:
				pause_button.show()
			get_tree().paused = true
		game_state.GAME_OVER:
			game_over.show()
			await get_tree().create_timer(2).timeout
			game_over.hide()
			current_game_state = game_state.NEW_GAME
			emit_signal("game_state_changed", current_game_state)
		game_state.NEW_GAME:
			if game_over.visible:
				game_over.hide()
			if pause_button.visible:
				pause_button.hide()
			start_button.show()
			$Player.start()
		game_state.RUNNING:
			if game_over.visible:
				game_over.hide()
			if pause_button.visible:
				pause_button.hide()
			if start_button.visible:
				start_button.hide()
			get_tree().paused = false

func check_for_stage_clear():
	if get_tree().get_nodes_in_group("enemies").is_empty():
		enemy_alive = false
		stage_cleared.emit()

func _on_stage_cleared():
	stage += 1
	show_stage_label()
	spawn_enemies()
