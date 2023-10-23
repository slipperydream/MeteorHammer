extends "res://enemy/base_enemy.gd"

@export var shoot_interval_min : float = 0.5
@export var shoot_interval_max : float = 2
@export var Attacks : Array[Attack] = []
@export var firing_sound : AudioStreamWAV

var sealing_range = 50
var attack_index : int = 0
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
	var attack = Attacks[attack_index]
	
	attack_index += 1
	if attack_index >= Attacks.size():
		attack_index = 0
	for x in range(attack.salvos):
		for shot in attack.Firing_Sequence:
			if shot.bullet_pattern is Circle_pattern:
				circle_pattern(shot)
			elif shot.bullet_pattern is Single_pattern:
				single_shot(shot)
			elif shot.bullet_pattern is Spread_pattern:
				spread_pattern(shot)
			elif shot.bullet_pattern is Flower_pattern:
				flower_pattern(shot)
			if shot.shot_delay > 0:
				await get_tree().create_timer(shot.shot_delay).timeout
		await get_tree().create_timer(attack.salvo_delay).timeout
				
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

func circle_pattern(new_shot):
	var points = new_shot.bullet_pattern.firing_points
	for point in range(points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		fire_bullet(shot, position, deg_to_rad(point * (360.0/points) + new_shot.angle))
		shot.set_speed(new_shot.speed)
		match new_shot.bullet_type:
			BulletConstants.BulletTypes.CURVED:
				shot.add_rotation(20)
			BulletConstants.BulletTypes.SPIRALING:
				shot.add_rotation(20)
		if new_shot.bullet_pattern.ripple:
			await get_tree().create_timer(new_shot.bullet_pattern.ripple_delay).timeout

func flower_pattern(new_shot):
	var points = new_shot.bullet_pattern.firing_points
	for point in range(points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		fire_bullet(shot, position, deg_to_rad(point * (360.0/points) + new_shot.angle))
		shot.set_speed(new_shot.speed)
		shot.set_bloom_timer(new_shot.bullet_pattern.bloom_delay)
		match new_shot.bullet_type:
			BulletConstants.BulletTypes.CURVED:
				shot.add_rotation(20)
			BulletConstants.BulletTypes.SPIRALING:
				shot.add_rotation(20)
		if new_shot.bullet_pattern.ripple:
			await get_tree().create_timer(new_shot.bullet_pattern.ripple_delay).timeout
				
func spread_pattern(new_shot):
	var points = new_shot.bullet_pattern.firing_points
	for point in range(points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		fire_bullet(shot, position, deg_to_rad(point * new_shot.bullet_pattern.separation_angle + new_shot.angle))
		shot.set_speed(new_shot.speed)
		match new_shot.bullet_type:
			BulletConstants.BulletTypes.CURVED:
				shot.add_rotation(20)
			BulletConstants.BulletTypes.SPIRALING:
				shot.add_rotation(20)
		if new_shot.bullet_pattern.ripple:
			await get_tree().create_timer(new_shot.bullet_pattern.ripple_delay).timeout
	
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
