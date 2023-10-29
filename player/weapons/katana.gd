extends Area2D

@export var title : String = "Cosmic Katana"
@export var speed : int = 450
@export var power : int = 5
@export var firing_sound : AudioStreamWAV

var slice_right : bool = true
var direction : Vector2 = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	rotation_degrees += rotation_speed
#	if rotation_degrees > 0 and rotation_degrees < 45:
#		position = position + speed * delta * direction * rotation_degrees
#	else:
	position = position + speed * delta * direction


func start(pos):
	AudioStreamManager.play(firing_sound.resource_path, true)
	global_position = pos
	slice_right = randi_range(0,1)
	if slice_right == false:
		$Sprite2D.flip_h = false
	var angle = 70
	
	if slice_right:
		rotation_degrees = -45
	else:
		angle = -70
		rotation_degrees = 45
		
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", angle, 1)
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(power)
				
# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_distance_timer_timeout():
	speed = 0
	queue_free()
