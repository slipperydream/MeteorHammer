extends "res://enemy/shooting_enemy.gd"
signal boss_leaving

var entered_screen : bool = false
var centered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)		
	
func old_shoot():
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

func _on_visible_on_screen_notifier_2d_screen_entered():
	entered_screen = true
	$MovementTimer.start()
	$ShootTimer.stop()

func _on_movement_timer_timeout():
	speed = 0
	if centered == false:
		centered = true
		$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
		$ShootTimer.start()
		$MilkingTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()
	
func _on_milking_timer_timeout():
	emit_signal("boss_leaving")
	speed = -50
