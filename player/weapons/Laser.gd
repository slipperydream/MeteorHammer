extends ShapeCast2D

@export var power : int = 1
@export var width : int = 50

var is_casting : bool = false:
	set(val):
		is_casting = val
		$ParticleOrigin.emitting = is_casting
		$ParticleQuarter.emitting = is_casting
		$ParticleMid.emitting = is_casting
		$ParticleThirdQuarter.emitting = is_casting
		$ParticleEnd.emitting = is_casting
		
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
	

#func _unhandled_input(event):
#	if event.is_action_pressed("laser"):
#		start()
#
func start():
	is_casting = true
	
func stop():
	is_casting = false

func _physics_process(delta):
	var cast_point = target_position
	force_shapecast_update()
	
	if is_colliding():
		for i in get_collision_count():
			cast_point = to_local(get_collision_point(i))
			var area = get_collider(i)
			if area.is_in_group("enemy"):
				area.take_damage(power)
	
	$Line2D.points[1] = cast_point
	$ParticleEnd.position = cast_point
	$ParticleQuarter.position = cast_point * 0.25
	$ParticleMid.position = cast_point * 0.5
	$ParticleThirdQuarter.position = cast_point * 0.75
	
func appear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", width, 0.2)
	print(shape.get_rect().size.x)
	
func disappear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.2)

