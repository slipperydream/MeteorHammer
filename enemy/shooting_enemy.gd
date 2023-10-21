extends "res://enemy/base_enemy.gd"

@export var shoot_interval_min : float = 0.5
@export var shoot_interval_max : float = 2
@export var FiringSequence : Array[Firing_pattern] = []
@export var required_range : int = 5

var bullet_scene : Array = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/base_enemy_weapon.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func explode():
	get_tree().call_group("enemy_weapon", "queue_free")
	super.explode()

func fire_bullet(bullet, pos, angle):
	get_tree().root.add_child(bullet)
	bullet.start(pos, Vector2.RIGHT.rotated(angle), 75)
	

func shoot():
	var pos = get_tree().get_first_node_in_group("player").position
	var dis = pos.distance_to(position) 
	if dis < required_range:
		print("player within sealing range")
		return
		
	var bullet = bullet_scene[0].instantiate()
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
