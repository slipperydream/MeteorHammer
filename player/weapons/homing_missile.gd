extends Area2D

signal target_lock

@export var title : String = "Homing Missile"
@export var speed : int = 150
@export var power : int = 5
@export var firing_sound : AudioStreamWAV
@export var steer_force = 100.0

var velocity = Vector2.ZERO
var target = null
var direction = Vector2(0,-1)


func start(pos):
	for enemy in get_tree().get_nodes_in_group("enemy"):
		target_lock.connect(enemy._on_homing_missile_target_lock)
	target = acquire_target()
	global_position = pos
	
func _physics_process(delta):
	if is_instance_valid(target):
		direction = (target.global_transform.origin - global_transform.origin).normalized()
	else:
		target = acquire_target()
	position += direction * speed * delta
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(power)
		queue_free()

# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func acquire_target():
	var closet_enemy = null
	var shortest_distance = INF
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		var distance = position.distance_to(enemy.position)
		if distance < shortest_distance:
			shortest_distance = distance
			closet_enemy = enemy
	
	if closet_enemy != null:
		emit_signal("target_lock", closet_enemy)
	return closet_enemy	
