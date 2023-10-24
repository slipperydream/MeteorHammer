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
@export var explosion_sound : AudioStreamWAV
var is_alive : bool = true
var vec_to_player : Vector2 = Vector2(0,1)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_GOB:
		z_index = 0
	else:
		z_index = 1
		$Sprite2D/Boosters.animation = "forward"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + enemy_size.y:
		remove()
	if faces_player:
		vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		var anim_direction = get_facing_direction(vec_to_player)
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
	set_deferred("monitoring", false)
	emit_signal("died", points)
	get_tree().call_group("enemy_weapon", "queue_free")
	explode()
	remove()

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	
func remove():
	queue_free()	

func _on_player_died():
	pass

func _on_visible_on_screen_notifier_2d_screen_entered():
	for child in get_children():
		if child is Shooting_component:
			child.start()

func _on_shooting_component_shooting():
	if $AnimationPlayer.get_animation("shooting"):
		$AnimationPlayer.play("shooting")
