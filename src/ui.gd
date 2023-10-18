extends MarginContainer

@onready var score_counter = $TopBarLeft/ScoreLabel
@onready var lives_counter = $BottomBar/PlayerLivesLabel
@onready var weapon_label = $BottomBar/Weapon
@onready var item_label = $BottomBar/Item

var num_lives = 0
var weapon : String = 'Beam'
var item : String = ''

func _ready():
	pass
	
func _on_main_score_changed(score):
	update_score(score)
	
func update_score(value):
	var s = "%08d" % value
	score_counter.text = str(s)

func update_lives(value):
	num_lives += value
	if lives_counter:
		lives_counter.text = "x%s" % str(num_lives)
	
func _on_player_died():
	update_lives(-1)

func _on_player_gained_life():
	update_lives(1)

func _on_player_out_of_lives():
	update_lives(0)
	
func _on_main_start_game(lives):
	update_lives(lives)

func _on_player_item_recharged():
	$AnimationPlayer.play("item_recharged")

func _on_player_item_changed(new_item):
	item_label.text = new_item

func _on_player_item_used():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("item_used")

func _on_player_weapon_changed(new_weapon):
	if weapon_label:
		weapon_label.text = new_weapon

func _on_player_item_charging():
	$AnimationPlayer.play("item_charging")
