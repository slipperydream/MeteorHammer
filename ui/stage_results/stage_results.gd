extends Control

signal results_closed
signal retry_level

@export var backgrounds : Array[Texture2D] = []
@export_range(1000, 50000) var star_value : int = 5000
@export var base_points : int = 1000
@onready var background = $PanelContainer/Sprite2D
@onready var screensize : Vector2 = get_viewport_rect().size

@onready var score = $Scorebar/ScoreLabel
@onready var base_counter = $Panel/VBoxContainer/BaseValue
@onready var boss_counter = $Panel4/VBoxContainer/BossBonus
@onready var continues_counter = $CenterPanel/MarginContainer/GridContainer/ContinuesCounter
@onready var deaths_counter = $CenterPanel/MarginContainer/GridContainer/DeathsCounter
@onready var destroyed_counter = $CenterPanel/MarginContainer/GridContainer/DestroyedCounter
@onready var hits_counter = $CenterPanel/MarginContainer/GridContainer/HitsCounter
@onready var multiplier_counter = $CenterPanel/MarginContainer/GridContainer/MultiplierCounter
@onready var progress_counter = $Panel2/VBoxContainer2/ProgressBonus
@onready var speed_counter = $Panel5/VBoxContainer/SpeedBonus

# Called when the node enters the scene tree for the first time.
func _ready():
	background.texture = backgrounds[randi() % backgrounds.size()]
	background.size.x = screensize.x
	background.size.y = screensize.y
	background.modulate = Color.AQUAMARINE

func update_base(value):
	base_counter.text = "%d" % value
	
func update_boss(value):
	var text = 2 if value else 1
	boss_counter.text = str(text)
	
func update_continues(value):
	continues_counter.text = str(value)
	
func update_deaths(value):
	deaths_counter.text = str(value)
	
func update_destroyed(value):
	destroyed_counter.text = str(value)
	
func update_hits(value):
	hits_counter.text = str(value)
		
func update_multiplier(value):
	multiplier_counter.text = str(value)

func update_progress(value):
	progress_counter = "%s" % value 

func update_speed(value):
	speed_counter.text = "%02.1f" % value

func update_score(results):
	var boss_bonus = 2 if results.boss_killed else 1
	var stage_bonus = base_points * results.progress 
	var speed_bonus = (60 - results.boss_kill_time) * 10
	var new_score = ceil(results.score + (stage_bonus * boss_bonus) + speed_bonus)
	score.text = str(new_score)
	update_stars(new_score)

func update_stars(value):
	var num_stars = min(5, floor(value / star_value))
	var stars = $Scorebar/HBoxContainer.get_children()
	for i in num_stars:
		stars[i].modulate = Color.WHITE	

func _on_main_end_stage(_stage, results):
	update_base(base_points)
	update_boss(results.boss_killed)
	update_continues(results.continues_used)
	update_deaths(results.times_died)
	update_destroyed(results.enemies_killed)
	update_hits(results.times_hit)
	update_multiplier(results.biggest_multiplier)
	update_progress(results.progress)
	update_speed(results.boss_kill_time)
	update_score(results)
	show()

func _on_continue_button_pressed():
	hide()
	emit_signal("results_closed")

func _on_retry_button_pressed():
	hide()
	emit_signal("retry_level")

