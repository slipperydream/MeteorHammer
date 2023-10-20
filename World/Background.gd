extends ParallaxBackground

@export var speed = 50.0

@export var direction = Vector2.DOWN
var saved_speed : int 
	
func _process(delta):
	scroll_base_offset += (speed * direction) * delta

func stop():
	saved_speed = speed
	print(saved_speed)
	speed = 0
	
func resume():
	speed = saved_speed
	print(speed)

func _on_main_level_cleared(_level):
	resume()
