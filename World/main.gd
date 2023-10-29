extends Node2D

@onready var screensize : Vector2 = get_viewport_rect().size

enum game_state {ATTRACT, TITLE, RUNNING, PAUSED, GAME_OVER}

signal game_over
signal pause_game
signal score_changed
signal score_multiplier
signal new_stage
signal player_start
signal end_stage

# achievement signals
signal high_multiplier
signal beat_game

var score = 0
var current_game_state : game_state = game_state.TITLE
var stage_num : int = 1
var stage : PackedScene
var boss_spawned = false
var scoring_chain_active : bool = false
var scoring_multiplier : int = 1
var stage_results = {
	path = '',
	name = '',
	score = 0,
	enemies_killed = 0,
	times_hit = 0,
	times_died = 0,
	credits_used = 0,
	biggest_multiplier = 0,
	progress = 0,
	boss_killed = false,
}
	

@export var start_lives = 3
@export var credits = 3
@export var scoring_timer : int = 5
@export var high_scoring_multiplier : int = 30

@onready var title_screen = $CanvasLayer/TitleScreen
@onready var stage_select = $CanvasLayer/StageSelect
@onready var results_screen = $CanvasLayer/StageResults

# Called when the node enters the scene tree for the first time.
func _ready():
	current_game_state = game_state.TITLE
	title_screen.show()
	BackgroundMusic.play_title_song()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_game_state == game_state.RUNNING and boss_spawned:
		check_for_stage_clear()

func begin_game():
	score = 0
	emit_signal("score_changed", score)
	stage_num = 1
	kill_sfx()
	emit_signal("player_start",start_lives, credits)
	current_game_state = game_state.RUNNING
	play_stage()

func check_for_stage_clear():
	if get_tree().get_nodes_in_group("boss").is_empty():
		boss_spawned = false
		stage_results.boss_killed = true
		emit_signal("end_stage", stage_num, stage_results)
		print(stage_results)
	
func kill_sfx():
	AudioStreamManager.clear_queue()
	AudioStreamManager.start()
		
func play_stage():
	reset_stage_results()
	var last_stage = get_tree().get_first_node_in_group("stage")
	if last_stage:
		last_stage.queue_free()
		
	BackgroundMusic.fade_in()
	BackgroundMusic.play_stage_theme(stage_num)
	
	var stage_instance = stage.instantiate()
	add_child(stage_instance)
	stage_instance.start()
	emit_signal("new_stage", stage_num)
	
func reset_stage_results():
	stage_results.score = 0
	stage_results.enemies_killed = 0
	stage_results.times_hit = 0
	stage_results.times_killed = 0
	stage_results.biggest_multiplier = 0
	stage_results.progress = 0
	stage_results.boss_killed = 0
	
func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		current_game_state = game_state.PAUSED
		emit_signal("pause_game")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
		
func _on_enemy_died(value):
	if scoring_chain_active:
		scoring_multiplier += 1
		if scoring_multiplier > stage_results.biggest_multiplier:
			stage_results.biggest_multiplier = scoring_multiplier;
		
		# achievement check
		if scoring_multiplier >= high_scoring_multiplier:
			emit_signal("high_multiplier")
	else:
		scoring_multiplier = 1
		
		$ScoringTimer.wait_time = scoring_timer
		$ScoringTimer.start()
		scoring_chain_active = true
	score += value * scoring_multiplier	
	stage_results.score = score
	emit_signal("score_multiplier", scoring_multiplier)
	stage_results.enemies_killed += 1
	emit_signal("score_changed", score)

func _on_player_died():
	stage_results.times_died += 1

func _on_player_out_of_lives():
	get_tree().call_group("enemies", "queue_free")
	credits -= 1
	credits = max(0, credits)
	var lives = start_lives
	if credits == 0:
		emit_signal("end_stage", stage_num, stage_results)
		current_game_state = game_state.GAME_OVER
		emit_signal("game_over")
		# then show stage results
		lives = 0
	emit_signal("player_start", lives, credits)

func _on_pause_game():
	get_tree().paused = true

func _on_game_over():
	get_tree().call_group("stages", "queue_free")

func _on_scoring_timer_timeout():
	scoring_chain_active = false
	scoring_multiplier = 1
	emit_signal("score_multiplier", scoring_multiplier)

func _on_boss_spawned():
	BackgroundMusic.fade_out()
	boss_spawned = true
	$Background.stop()
	await get_tree().create_timer(0.5).timeout
	BackgroundMusic.play_boss_theme(stage_num)
	stage_results.progress = 100
	
func _on_center_container_game_unpaused():
	current_game_state = game_state.RUNNING
	get_tree().paused = false

func _on_title_screen_boss_mode():
	stage = load("res://stages/Stage_1Boss.tscn")
	begin_game()

func _on_title_screen_attack_mode():
	stage = load("res://stages/Stage_1.tscn")
	begin_game()

func _on_player_player_hit():
	stage_results.times_hit += 0

func _on_new_background(file):
	$Background/ParallaxLayer/Sprite2D.texture = file

func _on_beat_game():
	_on_game_over()

func _on_end_stage(_current, _results):
	BackgroundMusic.fade_out()
	kill_sfx()

func _on_stage_results_results_closed():
	# need to make this aware if we are in story or attack mode
	stage_select.show()

func _on_title_screen_start_game():
	stage_select.show()

func _on_stage_select_stage_select_cancelled():
	title_screen.show()
	stage = null

func _on_stage_select_stage_selected(stage_path):
	stage = load(stage_path)
	stage_results.path = stage_path
	begin_game()

func _on_title_screen_exit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
func _on_stage_results_retry_level():
	play_stage()
