extends Control

@export var backgrounds : Array[Texture2D] = []
@export_range(1000, 50000) var star_value : int = 1000
@onready var background = $PanelContainer/Sprite2D
@onready var screensize : Vector2 = get_viewport_rect().size

@onready var score = $Scorebar/ScoreLabel
@onready var destroyed_counter = $GridContainer/DestroyedCounter
@onready var credits_counter = $GridContainer/CreditsCounter
@onready var hits_counter = $GridContainer/HitsCounter
@onready var deaths_counter = $GridContainer/DeathsCounter
@onready var multiplier_counter = $GridContainer/MultiplierCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	background.texture = backgrounds[randi() % backgrounds.size()]
	background.size.x = screensize.x
	background.size.y = screensize.y
	background.modulate = Color.AQUAMARINE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_score(value):
	score.text = str(value)

func update_stars(value):
	$Scorebar/HBoxContainer/Star.modulate = Color.GRAY
	$Scorebar/HBoxContainer/Star2.modulate = Color.GRAY
	$Scorebar/HBoxContainer/Star3.modulate = Color.GRAY
	$Scorebar/HBoxContainer/Star4.modulate = Color.GRAY
	$Scorebar/HBoxContainer/Star5.modulate = Color.GRAY
	var num_stars = floor(value / star_value)
	var stars = $Scorebar/HBoxContainer.get_children()
	for i in num_stars:
		stars[i].modulate = Color.WHITE	

func update_credits(value):
	credits_counter.text = str(value)
	
func update_deaths(value):
	deaths_counter.text = str(value)
	
func update_destroyed(value):
	destroyed_counter.text = str(value)
	
func update_hits(value):
	hits_counter.text = str(value)
		
func update_multiplier(value):
	multiplier_counter.text = str(value)

func _on_main_stage_cleared(stage, results):
	update_deaths(results.times_died)
	update_destroyed(results.enemies_killed)
	update_hits(results.times_hit)
	update_multiplier(results.biggest_multiplier)
