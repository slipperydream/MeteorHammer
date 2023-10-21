extends ParallaxBackground

@export var speed = 50.0

@export var direction = Vector2.DOWN
var saved_speed : float 
	
func _process(delta):
	scroll_base_offset += (speed * direction) * delta

func stop():
	saved_speed = speed
	print(saved_speed)
	speed = 0
	
func resume():
	speed = saved_speed
	print(speed)

func _on_main_stage_cleared(_stage):
	resume()
