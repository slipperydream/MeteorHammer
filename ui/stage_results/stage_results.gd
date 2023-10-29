extends Control

signal results_closed
signal retry_level

@export var backgrounds : Array[Texture2D] = []
@export_range(1000, 50000) var star_value : int = 10000
@export var base_points : int = 50
@onready var background = $PanelContainer/Sprite2D
@onready var screensize : Vector2 = get_viewport_rect().size

@onready var score = $Scorebar/ScoreLabel
@onready var boss_counter = $Panel4/VBoxContainer/BossBonus
@onready var credits_counter = $CenterPanel/MarginContainer/GridContainer/CreditsCounter
@onready var currency_counter = $Panel5/HBoxContainer/CurrencyEarned
@onready var deaths_counter = $CenterPanel/MarginContainer/GridContainer/DeathsCounter
@onready var destroyed_counter = $CenterPanel/MarginContainer/GridContainer/DestroyedCounter
@onready var hits_counter = $CenterPanel/MarginContainer/GridContainer/HitsCounter
@onready var multiplier_counter = $CenterPanel/MarginContainer/GridContainer/MultiplierCounter
@onready var progress_counter = $Panel2/VBoxContainer2/ProgressBonus
var path : String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	background.texture = backgrounds[randi() % backgrounds.size()]
	background.size.x = screensize.x
	background.size.y = screensize.y
	background.modulate = Color.AQUAMARINE

func calculate_currency(results):
	var boss_bonus = 2 if results.boss_killed else 1
	var currency_earned = base_points * results.progress * boss_bonus
	update_currency(currency_earned)

func update_boss(value):
	var text = 2 if value else 1
	boss_counter.text = str(text)
	
func update_credits(value):
	credits_counter.text = str(value)

func update_currency(value):
	currency_counter.text = str(value)
	
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

func update_score(value):
	score.text = str(value)

func update_stars(value):
	var num_stars = min(5, floor(value / star_value))
	var stars = $Scorebar/HBoxContainer.get_children()
	for i in num_stars:
		stars[i].modulate = Color.WHITE	
		

func _on_main_end_stage(_stage, results):
	path = results.path
	update_boss(results.boss_killed)
	update_deaths(results.times_died)
	update_destroyed(results.enemies_killed)
	update_hits(results.times_hit)
	update_multiplier(results.biggest_multiplier)
	update_progress(results.progress)
	update_score(results.score)
	update_stars(results.score)
	calculate_currency(results)
	show()

func _on_continue_button_pressed():
	hide()
	emit_signal("results_closed")

func _on_retry_button_pressed():
	hide()
	emit_signal("retry_level", path)

