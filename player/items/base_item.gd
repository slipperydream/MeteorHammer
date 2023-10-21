extends Area2D

@export var activation_sound : AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func execute(_pos):
	if activation_sound:
		AudioStreamManager.play(activation_sound.resource_path, false)
