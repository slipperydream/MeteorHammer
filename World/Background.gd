extends ParallaxBackground

@export var speed = 50.0

@export var direction = Vector2.DOWN

func _process(delta):
	scroll_base_offset += (speed * direction) * delta

func set_speed(in_speed):
	speed = in_speed
