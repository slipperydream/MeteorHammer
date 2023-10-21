extends RayCast2D

var is_casting : bool = false:
	set(val):
		is_casting = val
		if is_casting:
			appear()
		else:
			disappear()
		set_physics_process(is_casting)
	get:
		return is_casting

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO

func _unhandled_input(event):
	if event.is_action_pressed("laser"):
		is_casting = event.is_pressed()

func _physics_process(delta):
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	$Line2D.points[1] = cast_point

func appear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 10.0, 0.2)
	
func disappear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.2)
