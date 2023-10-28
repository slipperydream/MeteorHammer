extends CenterContainer

signal game_unpaused
signal start_pressed

@onready var pause_button = $PauseButton
@onready var game_over_label = $GameOver
@onready var stage_label = $StageLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	if game_over_label.visible:
		game_over_label.hide()
	if pause_button.visible:
		pause_button.hide()
	if stage_label.visible:
		stage_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_stage_label(stage):
	stage_label.text = "Stage %d" % (stage)
	stage_label.show()
	await get_tree().create_timer(2).timeout
	stage_label.hide()

func _on_main_pause_game():
	if game_over_label.visible:
		game_over_label.hide()
	if pause_button.visible == false:
		pause_button.show()

func _on_main_game_over():
	display_game_end("Game Over")

func _on_pause_button_pressed():
	emit_signal("game_unpaused")
	pause_button.hide()

func _on_main_new_stage(stage):
	if game_over_label.visible:
		game_over_label.hide()
	if pause_button.visible:
		pause_button.hide()
	show_stage_label(stage)
	

func _on_main_beat_game():
	display_game_end("You Win!")

func display_game_end(text):
	game_over_label.text = text
	game_over_label.show()
	await get_tree().create_timer(2).timeout
	game_over_label.hide()

