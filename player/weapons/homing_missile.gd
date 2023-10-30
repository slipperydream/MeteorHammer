extends Area2D

signal target_lock

@export var title : String = "Cosmic Katana"
@export var speed : int = -250
@export var power : int = 5
var direction : Vector2 = Vector2(0, 1)
@export var firing_sound : AudioStreamWAV
@export var steer_force = 50.0

var vec_to_target : Vector2 = Vector2(0,1)
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	acquire_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null:
		acquire_target()
	position = position + speed * delta * direction + steer_towards_target(delta)
	
	if target:
		vec_to_target = (target.global_position - global_position).normalized()
		
		var anim_direction = get_facing_direction(vec_to_target)
		if $AnimationPlayer.has_animation(anim_direction):
			$AnimationPlayer.play(anim_direction)

func acquire_target():
	target = get_tree().get_first_node_in_group("enemy")
	emit_signal("target_lock", target)
	
func get_facing_direction(vtp):
	var facing_vec = get_facing_vector(vtp)
	return EnemyConstants.FACING[facing_vec]
	
func get_facing_vector(vtp):
	var min_angle = 360
	var facing = Vector2()
	for vec in EnemyConstants.FACING.keys():
		var ang = abs(vtp.angle_to(vec))
		if ang < min_angle:
			min_angle = ang
			facing = vec
	return facing

func steer_towards_target(delta):
	var steer = Vector2.ZERO
	if target:
		var desired = vec_to_target * speed
		steer = (desired - direction).normalized() * steer_force * delta
	return steer

func start(pos):
	AudioStreamManager.play(firing_sound.resource_path, true)
	position = pos
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(power)
		queue_free()

# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
