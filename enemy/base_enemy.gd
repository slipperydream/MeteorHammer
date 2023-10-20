extends Area2D

signal died

var bullet_scene = preload("res://enemy/weapons/base_enemy_weapon.tscn")

@export var title : String = "Enemy"
@export var is_boss : bool = false
@export var points : int = 5
@export var speed : int = 30
@export var hp : int = 1
@export var shoot_interval_min : float = 0.5
@export var shoot_interval_max : float = 2
@export var required_range : int = 5
@export var explosion_sound : AudioStreamWAV


@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + enemy_size.y:
		remove()
	
func start(pos):
	position = Vector2(pos.x, pos.y)
	$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
	$ShootTimer.start()

func take_damage(value):
	hp = max(0, hp - value)
	if hp == 0:
		explode()
	else:
		$AnimationPlayer.play("hit")
		
func explode():
	speed = 0
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.play("explode")
	emit_signal("died", points)
	await $AnimationPlayer.animation_finished
	remove()

func remove():
	set_deferred("monitoring", false)
	queue_free()	

func _on_shoot_timer_timeout():
	shoot()
	$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
	$ShootTimer.start()

func _on_player_died():
	print("player died. stopping shots")
	$ShootTimer.wait_time = 3
	$ShootTimer.start()

func shoot():
	var pos = get_tree().get_first_node_in_group("player").position
	var dis = pos.distance_to(position) 
	if dis < required_range:
		print("player within sealing range")
		return
		
	var bullet = bullet_scene.instantiate()
	fire_bullet(bullet, position, deg_to_rad(90))
	
	# TODO: Move all this into individual enemies shot patterns
				
#		shot_spreads.DOUBLE_STACK:			
#		var bullet = bullet_scene.instantiate()
#
#		# calculate separtion between shots
#		var sprite = bullet.get_node("Sprite2D")
#		var frames = sprite.get_hframes()
#		var width = sprite.texture.get_size().x
#		var spacing = width / (frames * frames)
#		fire_bullet(bullet, Vector2(position.x-spacing, position.y), deg_to_rad(90))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, Vector2(position.x+spacing, position.y), deg_to_rad(90))
#		shot_spreads.TRIPLE_STACK:
#		var bullet = bullet_scene.instantiate()
#
#		# calculate separtion between shots
#		var sprite = bullet.get_node("Sprite2D")
#		var frames = sprite.get_hframes()
#		var width = sprite.texture.get_size().x
#		var spacing = width / frames / 2
#		fire_bullet(bullet, Vector2(position.x-spacing, position.y), deg_to_rad(90))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, Vector2(position.x+spacing, position.y), deg_to_rad(90))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(90))
#
#		shot_spreads.VEE:
#		var bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(80))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(100))
#
#		shot_spreads.W:
#		var bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(75))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(90))
#		bullet = bullet_scene.instantiate()
#		fire_bullet(bullet, position, deg_to_rad(105))
#
#		shot_spreads.SPREADSHOT:
#		for point in range(5):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 60))
#
#		shot_spreads.SPREADSHOT_RIPPLE:
#		for point in range(5):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 60))	
#			await get_tree().create_timer(0.25).timeout
#
#		shot_spreads.PENDULUM:
#		for point in range(5):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 60))	
#			await get_tree().create_timer(0.25).timeout
#		for point in range(4, 0, -1):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 60))	
#			await get_tree().create_timer(0.25).timeout
#
#		shot_spreads.CROSS:
#		for point in range(8):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 90))
#
#		shot_spreads.CARDINAL:
#		for point in range(8):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 45))
#
#		shot_spreads.CIRCLE:
#		for point in range(24):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15))
#
#		shot_spreads.WHIP:
#		for point in range(24):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15))
#			await get_tree().create_timer(0.1).timeout
#
#		shot_spreads.TWO_WHIPS:
#		for point in range(24):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15))
#			bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 180))
#			await get_tree().create_timer(0.1).timeout
#
#		shot_spreads.FOUR_WHIPS:
#		for point in range(24):
#			var bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15))
#			bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 90))
#			bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 180))
#			bullet = bullet_scene.instantiate()
#			fire_bullet(bullet, position, deg_to_rad(point * 15 + 270))
#			await get_tree().create_timer(0.1).timeout

func fire_bullet(bullet, pos, angle):
	get_tree().root.add_child(bullet)
	bullet.start(pos, Vector2.RIGHT.rotated(angle))
