extends Area2D

@export var title : String = "Cosmic Katana"
@export var speed : int = 50
@export var power : int = 5
@export var rotation_speed = 1
@export var firing_sound : AudioStreamWAV

var direction : Vector2 = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += rotation_speed
	if rotation_degrees > 0 and rotation_degrees < 45:
		position = position + speed * delta * direction * rotation_degrees
	else:
		position = position + speed * delta * direction


func start(pos):
	AudioStreamManager.play(firing_sound.resource_path, true)
	global_position = pos
	rotation_degrees = -15
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(power)
				
# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_distance_timer_timeout():
	speed = 0
	queue_free()
