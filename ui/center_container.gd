extends CenterContainer

signal game_unpaused
signal start_pressed

@onready var start_button = $StartButton
@onready var pause_button = $PauseButton
@onready var game_over_label = $GameOver
@onready var stage_label = $StageLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_stage_label(stage):
	stage_label.text = "Stage %d" % (stage + 1)
	stage_label.show()
	await get_tree().create_timer(2).timeout
	stage_label.hide()

func _on_start_button_pressed():
	start_button.hide()
	emit_signal("start_pressed")

func _on_main_new_game():
	if game_over_label.visible:
		game_over_label.hide()
	if pause_button.visible:
		pause_button.hide()
	start_button.show()

func _on_main_pause_game():
	if game_over_label.visible:
		game_over_label.hide()
	if start_button.visible:
		start_button.hide()
	if pause_button.visible == false:
		pause_button.show()

func _on_main_game_over():
	game_over_label.show()
	await get_tree().create_timer(2).timeout
	game_over_label.hide()

func _on_pause_button_pressed():
	emit_signal("game_unpaused")
	pause_button.hide()

func _on_main_new_stage(stage):
	show_stage_label(stage)
