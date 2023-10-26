extends Area2D

@export var title : String = 'enemy weapon'
@export var animate : bool = true
@export var bullet_type : BulletConstants.BulletTypes = BulletConstants.BulletTypes.STRAIGHT

# Vector2(0, 1) is down 
var direction : Vector2 = Vector2(0, 1)
var speed : int = 60
var added_rotation : Vector2 = Vector2(0, 1)
var power : int = 1
var time : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 2
	audio_bus_override = true
	audio_bus_name = 'SFX'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match bullet_type:
		BulletConstants.BulletTypes.STRAIGHT:
			position = position + speed * delta * direction 
		BulletConstants.BulletTypes.CURVED:
			position = position + speed * delta * (direction * added_rotation)
		BulletConstants.BulletTypes.SPIRALING:
			position = position + speed * delta * direction
		BulletConstants.BulletTypes.WAVY:
			time += delta
			var frequency = 5
			var amplitude = 10
			direction.x = cos(time * frequency * amplitude)
			position = position + speed * delta * direction 
	look_at(position)
	
	if animate and $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("moving")

func _on_area_entered(area):
	if area.name == "Player":
		area.take_damage(power)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_size(size = Vector2(0.5, 0.5)):
	$Sprite2D.apply_scale(size)
	$CollisionShape2D.apply_scale(size)

func set_type(type):
	bullet_type = type

func add_rotation(new_value):
	added_rotation = Vector2.RIGHT.rotated(new_value)
	
func set_speed(new_value):
	speed = new_value

func set_bloom_timer(wait_time):
	await get_tree().create_timer(wait_time).timeout
	print("blooming")
	queue_free()
	
func start(pos, dir):
	position = pos
	direction = dir
#	var angle = get_angle_to(position)
#	$Sprite2D.rotation = angle

	
