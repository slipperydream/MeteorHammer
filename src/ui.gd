extends MarginContainer

@onready var shield_bar = $TopBars/ShieldBar
@onready var score_counter = $TopBars/ScoreLabel

var life_scene = preload("res://scenes/player_life.tscn")
	
func update_score(value):
	var s = "%08d" % value
	$TopBars/ScoreLabel.text = str(s)
	
func update_shield(max_value, value):
	shield_bar.max_value = max_value
	shield_bar.value = value

func _on_player_shield_changed(max_value, value):
	update_shield(max_value, value)

func _on_main_score_changed(score):
	update_score(score)

func update_lives(value):
	if value > 0:
		for i in value:
			var life = life_scene.instantiate()
			get_node("TopBars/LivesContainer").add_child(life)
			print("adding life")
	if value < 0:
		var life = get_node("TopBars/LivesContainer").get_child(0)
		life.queue_free()
	if value == 0:
		var lives = get_node("TopBars/LivesContainer").get_children()
		for life in lives:
			life.queue_free()
	
func _on_player_died():
	update_lives(-1)

func _on_player_gained_life():
	update_lives(1)


func _on_main_game_state_changed(value):
	match value:
		1: 
			print("new game")
			update_lives(3)


func _on_player_out_of_lives():
	update_lives(0)
