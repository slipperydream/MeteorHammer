extends Area2D

@export var speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta

func _on_area_entered(area):
	if area.name == "Player":
		queue_free()
		area.shield -= 1

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func start(pos):
	position = pos
