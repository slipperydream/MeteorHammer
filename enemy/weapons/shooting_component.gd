extends Node2D

class_name Shooting_component

signal shooting

@export var shot_timer : float = 2
@export var Attacks : Array[Attack] = []
@export var firing_sound : AudioStreamWAV
@export var sealing_range = 0
@export var stations : Array[Marker2D] = []
var attack_index : int = 0

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func check_sealing_range():
	var pos = player.position
	var dis = pos.distance_to(position)
	if dis < sealing_range:
		return true

func get_angle_to_player():
	var vec_to_player : Vector2
	vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	return vec_to_player.angle()		

func get_station_position(index):
	return stations[index].global_position
			
func fire_bullet(bullet, pos, angle):
	get_tree().root.add_child(bullet)
	bullet.start(pos, Vector2.RIGHT.rotated(angle))
	AudioStreamManager.play(firing_sound.resource_path, true)

func shoot():
	if check_sealing_range():
		print("player within sealing range")
		return
	
	emit_signal("shooting")
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
	var angle = new_shot.angle
	if new_shot.aimed:
		angle = get_angle_to_player()
	var pos = get_station_position(new_shot.station)
	fire_bullet(shot, pos, deg_to_rad(angle))
	shot.set_speed(new_shot.speed)
	match new_shot.bullet_type:
		BulletConstants.BulletTypes.CURVED:
			shot.add_rotation(20)
		BulletConstants.BulletTypes.SPIRALING:
			shot.add_rotation(20)

func circle_pattern(new_shot):
	var firing_points = new_shot.bullet_pattern.firing_points
	for point in range(firing_points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		var angle = new_shot.angle
		if new_shot.aimed:
			angle = get_angle_to_player()
		var pos = get_station_position(new_shot.station)
		fire_bullet(shot, pos, deg_to_rad(point * (360.0/firing_points) + angle))
		shot.set_speed(new_shot.speed)
		match new_shot.bullet_type:
			BulletConstants.BulletTypes.CURVED:
				shot.add_rotation(20)
			BulletConstants.BulletTypes.SPIRALING:
				shot.add_rotation(20)
		if new_shot.bullet_pattern.ripple:
			await get_tree().create_timer(new_shot.bullet_pattern.ripple_delay).timeout

func flower_pattern(new_shot):
	var firing_points = new_shot.bullet_pattern.firing_points
	for point in range(firing_points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		var angle = new_shot.angle
		if new_shot.aimed:
			angle = get_angle_to_player()
		var pos = get_station_position(new_shot.station)
		fire_bullet(shot, pos, deg_to_rad(point * (360.0/firing_points) + angle))
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
	var firing_points = new_shot.bullet_pattern.firing_points
	for point in range(firing_points):
		var shot = new_shot.bullet_shape.instantiate()
		shot.set_type(new_shot.bullet_type)
		shot.set_size()
		var angle = new_shot.angle
		if new_shot.aimed:
			angle = get_angle_to_player()
		var pos = get_station_position(new_shot.station)
		fire_bullet(shot, pos, deg_to_rad(firing_points * new_shot.bullet_pattern.separation_angle + angle))
		shot.set_speed(new_shot.speed)
		match new_shot.bullet_type:
			BulletConstants.BulletTypes.CURVED:
				shot.add_rotation(20)
			BulletConstants.BulletTypes.SPIRALING:
				shot.add_rotation(20)
		if new_shot.bullet_pattern.ripple:
			await get_tree().create_timer(new_shot.bullet_pattern.ripple_delay).timeout
			
func start():
	$ShootTimer.wait_time = shot_timer
	$ShootTimer.start()

func stop_shooting():
	$ShootTimer.stop()
	
func _on_player_died():
	print("player died. stopping shots")
	$ShootTimer.wait_time = 3
	$ShootTimer.start()
	
func _on_shoot_timer_timeout():
	shoot()
	$ShootTimer.wait_time = shot_timer
	$ShootTimer.start()
