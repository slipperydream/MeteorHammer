extends "res://enemy/shooting_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/arrow_ball.tscn"))
	bullet_scene.append(preload("res://enemy/weapons/spinning_bullet.tscn"))
	bullet_scene.append(preload("res://enemy/weapons/elipse.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	var pos = get_tree().get_first_node_in_group("player").position
	var dis = pos.distance_to(position) 
	if dis < required_range:
		speed = 0

func shoot():
	# keep pushing the player out to the sides then up
	$AnimationPlayer.play("shooting")
	await get_tree().create_timer(0.15).timeout
	for j in range(5):
		for i in range(5):
			var bullet = bullet_scene[0].instantiate()	
			fire_bullet(bullet, Vector2(position.x, position.y+ enemy_size.y/2), deg_to_rad(60 + (i * 15)))
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.2).timeout

	for j in range(5):
		for i in range(5):
			var bullet = bullet_scene[1].instantiate()	
			fire_bullet(bullet, Vector2(position.x - enemy_size.x/2, position.y), deg_to_rad(90 + (i * 15)))
			bullet = bullet_scene[1].instantiate()	
			fire_bullet(bullet, Vector2(position.x + enemy_size.x/2, position.y), deg_to_rad(90 - (i * 15)))
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.3).timeout

	for j in range(5):
		for i in range(5):
			var bullet = bullet_scene[2].instantiate()	
			fire_bullet(bullet, Vector2(position.x, position.y - enemy_size.y/2), deg_to_rad(0+i*15))
			bullet = bullet_scene[2].instantiate()	
			fire_bullet(bullet, Vector2(position.x, position.y - enemy_size.y/2), deg_to_rad(180-i*15))
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.3).timeout
	
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
