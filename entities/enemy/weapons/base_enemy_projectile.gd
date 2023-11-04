extends Area2D

class_name Enemy_weapon

@export var title : String = 'enemy weapon'
@export var animate : bool = true
@export var bullet_type : BulletConstants.BulletTypes = BulletConstants.BulletTypes.STRAIGHT
@onready var target = get_tree().get_first_node_in_group("player")

# Vector2(0, 1) is down 
var direction : Vector2 = Vector2(0, 1)
var speed : int = 60
var added_rotation : Vector2 = Vector2(0, 1)
var power : int = 1
var time : int = 0
var is_cancelled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 2
	audio_bus_override = true
	audio_bus_name = 'SFX'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_cancelled:
		position += (target.position - position).normalized() * speed * delta
	else:
		match bullet_type:
			BulletConstants.BulletTypes.STRAIGHT:
				position = position + speed * delta * direction 
			BulletConstants.BulletTypes.CURVED:
				#Try this one out
				#position = position + speed * direction.rotated(added_rotation) * delta
				position = position + speed * delta * (direction * added_rotation)
			BulletConstants.BulletTypes.SPIRALING:
				position = position + speed * delta * direction
			BulletConstants.BulletTypes.WAVY:
				time += delta
				var frequency = 5
				var amplitude = 10
				direction.x = cos(time * frequency * amplitude)
				position = position + speed * delta * direction 
	
		if animate and $AnimationPlayer.is_playing() == false:
			$AnimationPlayer.play("moving")

func _on_area_entered(area):
	if area is Player:
		if is_cancelled:
			pass
		else:
			area.take_damage(power, DamageConstants.DamageTypes.BULLET)
			remove()

func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()

func set_size(size = Vector2(1, 1)):
	$Sprite2D.apply_scale(size)
	$CollisionShape2D.apply_scale(size)

func set_type(type):
	bullet_type = type

func remove():
	queue_free()
	
func add_rotation(new_value):
	added_rotation = Vector2.RIGHT.rotated(new_value)
	
func set_speed(new_value):
	speed = new_value

func set_bloom_timer(wait_time):
	await get_tree().create_timer(wait_time).timeout
	print("blooming")
	queue_free()
	
func start(pos, dir, angle):
	position = pos
	direction = dir
	rotation_degrees = angle - 90

func cancel_bullet():
	is_cancelled = true
	animate = false
	for child in get_children():
		if child is AnimationPlayer:
			$AnimationPlayer.stop()
