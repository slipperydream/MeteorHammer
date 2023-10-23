extends "res://enemy/base_enemy.gd"

@export var shoot_interval_min : float = 0.5
@export var shoot_interval_max : float = 2
@export var Attacks : Array[Attack] = []
@export var firing_sound : AudioStreamWAV

var sealing_range = 50

var bullet_scene : Array = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/base_enemy_projectile.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func explode():
	get_tree().call_group("enemy_weapon", "queue_free")
	super.explode()

func fire_bullet(bullet, pos, angle):
	get_tree().root.add_child(bullet)
	bullet.start(pos, Vector2.RIGHT.rotated(angle))
	AudioStreamManager.play(firing_sound.resource_path, true)
	

func shoot():
	$AnimationPlayer.play("shooting")
	await get_tree().create_timer(0.15).timeout
	var attack = Attacks[randi() % Attacks.size()]
	for shot in attack.Firing_Sequence:
		match shot.bullet_pattern:
			BulletConstants.BulletPatterns.SINGLE:
				single_shot(shot)
				
func single_shot(new_shot):
	var shot = new_shot.bullet_shape.instantiate()
	shot.set_type(new_shot.bullet_type)
	shot.set_size()
	fire_bullet(shot, position, deg_to_rad(new_shot.angle))
	shot.set_speed(new_shot.speed)
	match new_shot.bullet_type:
		BulletConstants.BulletTypes.CURVED:
			shot.add_rotation(20)
		BulletConstants.BulletTypes.SPIRALING:
			shot.add_rotation(20)
	
	
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
	
func start(pos):
	super.start(pos)
	$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
	$ShootTimer.start()
	
func _on_player_died():
	print("player died. stopping shots")
	$ShootTimer.wait_time = 3
	$ShootTimer.start()
	
func _on_shoot_timer_timeout():
	shoot()
	$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
	$ShootTimer.start()
