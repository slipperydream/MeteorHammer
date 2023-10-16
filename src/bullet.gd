extends Area2D

@export var speed = -250
@export var direction : Vector2 = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction

func start(pos):
	position = pos
	
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
