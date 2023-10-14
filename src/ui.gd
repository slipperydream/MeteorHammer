extends MarginContainer

@onready var shield_bar = $TopBars/ShieldBar
@onready var score_counter = $TopBars/ScoreLabel

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
