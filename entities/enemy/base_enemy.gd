extends Node2D

class_name Enemy

signal died

@export var title : String = "Enemy"
@export var points : int = 100
@export var speed : int = 30
@export var faces_player : bool = false
@export var explosion_sound : AudioStreamWAV

var is_alive : bool = true
var is_offscreen : bool = true
var vec_to_player : Vector2 = Vector2(0,1)
var targeted : bool = false
var direction : Vector2 = Vector2(0,1)
	
@onready var player = get_tree().get_first_node_in_group("player")
@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size
@onready var ceasefire_line : float = screensize.y * 0.9
@onready var stopwatch = $Stopwatch
@onready var parent = get_parent()
@onready var health_component : HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_in_group("ground"):
		z_index = 0
	else:
		z_index = 1
	
	if parent is PathFollow2D:
		parent.progress = 0
		
	$Sprite2D/TargetLock.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if parent is PathFollow2D:
		parent.progress += speed * delta
		if parent.progress_ratio >= 1:
			if is_offscreen:
				remove()
	else:
		position = position + speed * delta * direction
	
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

func take_damage(value, source):
	health_component.take_damage(value, source)
				
func die(source):
	speed = 0
	set_deferred("monitoring", false)
	var bonus = calculate_bonus()
	show_points(bonus)
	emit_signal("died", (points+bonus), source)
	get_tree().call_group("enemy_weapon", "queue_free")
	create_item(source)
	explode()

func calculate_bonus():
	stopwatch.stop()
	var bonus = points - (10 * floor(stopwatch.time_elapsed))
	bonus = max(0, bonus)
	return bonus
	
func show_points(bonus):
	var death_points = Points_label.new()
	get_tree().get_first_node_in_group("stage").add_child(death_points)
	death_points.display(global_position + Vector2(20, -32), points, bonus)

func create_item(source):
	match source:
		DamageConstants.DamageTypes.BULLET:
			print("killed by bullet")
		DamageConstants.DamageTypes.LASER:
			print("killed by laser")
		DamageConstants.DamageTypes.BOMB:
			print("killed by bomb")
		DamageConstants.DamageTypes.SPECIAL:
			print("killed by special")
			
func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	remove()
		
func remove():
	queue_free()	


func _on_visible_on_screen_notifier_2d_screen_entered():
	stopwatch.start()
	is_offscreen = true
	for child in get_children():
		if child is Shooting_component:
			child.start()

func _on_shooting_component_shooting():
	if $AnimationPlayer.has_animation("shooting"):
		$AnimationPlayer.play("shooting")

func _on_player_target_lock(target):
	if target == self:
		targeted = true
		$Sprite2D/TargetLock.show()
				
func _on_visible_on_screen_notifier_2d_screen_exited():
	is_offscreen = true

func _on_health_component_hit():
	$AnimationPlayer.play("hit")

func _on_health_component_killed(source):
	die(source)

