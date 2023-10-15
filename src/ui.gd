extends MarginContainer

@onready var shield_bar = $TopBars/ShieldBar
@onready var score_counter = $TopBars/ScoreLabel

var num_lives = 0
var weapon : String = 'Beam'
var item : String = ''

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
	num_lives += value
	$TopBars/LivesContainer/PlayerLivesLabel.text = "x%s" % str(num_lives)
	
func _on_player_died():
	print('dead')
	update_lives(-1)

func _on_player_gained_life():
	update_lives(1)

func _on_main_game_state_changed(value):
	match value:
		1: 
			update_lives(3)
		

func _on_player_out_of_lives():
	update_lives(0)
