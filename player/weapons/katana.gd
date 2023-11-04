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
	#position = position + speed * delta * direction
	pass


func start(pos):
	AudioStreamManager.play(firing_sound.resource_path, true)
	
	var end_pos = Vector2(-25, -10)
	slice_right = randi_range(0,1)
	if slice_right == true:
		global_position = Vector2(-10, pos.y)
		end_pos.x = 625
	else:
		global_position = Vector2(610, pos.y)
		$Sprite2D.flip_h = true		
		
	var tween = create_tween()
	tween.tween_property(self, "position", end_pos, 1)
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(power)
				
# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_distance_timer_timeout():
	speed = 0
	queue_free()
