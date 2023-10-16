extends Area2D

@export var speed : int = 150
@export var direction : Vector2 = Vector2(0, 1)
@export var power : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction

func _on_area_entered(area):
	if area.name == "Player":
		queue_free()
		area.take_damage(power)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func start(pos, dir):
	position = pos
	direction = dir
