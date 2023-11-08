extends Node2D

@export var title : String = "Missile"
@export var speed : int = 100
@export var power : int = 5
@export var firing_sound : AudioStreamWAV

var direction = Vector2(0,-1)
var target = null
@onready var damage_type = DamageConstants.DamageTypes.SPECIAL

func start(_transform, tgt):
	target = tgt
	global_transform = _transform
	$AnimationPlayer.play("flying")

func _physics_process(delta):	
	if is_instance_valid(target):
		direction = (target.global_transform.origin - global_transform.origin).normalized()
		look_at(target.global_position)
	else:
		direction = direction + Vector2(randf_range(-0.5,0.5),randf_range(-0.01, 0.01))
	position += direction * speed * delta


# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		area.take_damage(power, damage_type)
		queue_free()
