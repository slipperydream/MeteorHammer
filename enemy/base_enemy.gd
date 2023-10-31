extends Area2D

class_name Enemy

signal died

@export var title : String = "Enemy"
@export var points : int = 100
@export var speed : int = 30
@export var hp : int = 5
@export var is_boss : bool = false
@export var is_GOB : bool = false
@export var faces_player : bool = false
@export var direction : Vector2 = Vector2(0,1)
@export var homing : bool = false
@export var steer_force = 50.0
@export var explosion_sound : AudioStreamWAV
@export var life_expectancy : int = 8

var is_alive : bool = true
var vec_to_player : Vector2 = Vector2(0,1)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size
@onready var ceasefire_line : float = screensize.y * 0.9
@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_GOB:
		z_index = 0
	else:
		z_index = 1
	if parent is PathFollow2D:
		parent.progress = 0
		
	$Sprite2D/TargetLock.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent is PathFollow2D:
		parent.progress += 250 * delta
		if parent.progress_ratio == 1:
			remove()
	else:
		position = position + speed * delta * direction + steer_towards_player(delta)
		
		# left the screen so remove
		if position.y > screensize.y + enemy_size.y:
			remove()
			
	# ceasefire once in the bottom 10% of the screen to prevent frustration
	if position.y > ceasefire_line:
		for child in get_children():
			if child is Shooting_component:
				child.stop_shooting()
			
	if faces_player:
		vec_to_player = (player.global_position - global_position).normalized()
		var anim_direction = get_facing_direction(vec_to_player)
		if $AnimationPlayer.has_animation(anim_direction):
			$AnimationPlayer.play(anim_direction)

func get_facing_vector(vtp):
	var min_angle = 360
	var facing = Vector2()
	for vec in EnemyConstants.FACING.keys():
		var ang = abs(vtp.angle_to(vec))
		if ang < min_angle:
			min_angle = ang
			facing = vec
	return facing

func get_facing_direction(vtp):
	var facing_vec = get_facing_vector(vtp)
	return EnemyConstants.FACING[facing_vec]
		
func start(pos):
	position = Vector2(pos.x, pos.y)

func take_damage(value):
	if is_alive == false:
		return
	hp = max(0, hp - value)
	if hp == 0:
		is_alive = false
		die()
	else:
		$AnimationPlayer.play("hit")
				
func die():
	speed = 0
	calculate_points()
	show_points()
	set_deferred("monitoring", false)
	emit_signal("died", points)
	get_tree().call_group("enemy_weapon", "queue_free")
	explode()

func calculate_points():
	$Stopwatch.stop()
	if life_expectancy > $Stopwatch.time_elapsed:
		var diff = life_expectancy - floor($Stopwatch.time_elapsed)
		var bonus = points * (diff/10)
		points += bonus
	
		
func show_points():
	var death_points = Points_label.new()
	get_tree().get_first_node_in_group("canvas").add_child(death_points)
	death_points.display(global_position + Vector2(20, -32), points)

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	remove()
		
func remove():
	queue_free()	

func steer_towards_player(delta):
	var steer = Vector2.ZERO
	if homing:
		if player:
			var desired = vec_to_player * speed
			steer = (desired - direction).normalized() * steer_force * delta
	return steer
	
func _on_player_died():
	pass

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Stopwatch.start()
	for child in get_children():
		if child is Shooting_component:
			child.start()

func _on_shooting_component_shooting():
	if $AnimationPlayer.has_animation("shooting"):
		$AnimationPlayer.play("shooting")

func _on_homing_missile_target_lock(target):
	if target == self:
		$Sprite2D/TargetLock.show()
