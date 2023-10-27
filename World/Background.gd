extends ParallaxBackground

@export var speed = 75.0

@export var direction = Vector2.DOWN
var saved_speed : float 
	
func _process(delta):
	scroll_base_offset += (speed * direction) * delta

func stop():
	saved_speed = speed
	speed = 0
	
func resume():
	speed = saved_speed

func _on_main_end_stage(_stage, _stage_results):
	resume()
