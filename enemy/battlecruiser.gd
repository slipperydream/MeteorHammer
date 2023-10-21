extends "res://enemy/base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/cross_shot.tscn"))
	bullet_scene.append(preload("res://enemy/weapons/slice.tscn"))
	bullet_scene.append(preload("res://enemy/weapons/needle.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$Sprite2D/Boosters.animation = "forward"

func shoot():
	# Craziness is to get it to mostly match the animation
	$AnimationPlayer.play("shooting")
	var bullet = bullet_scene[1].instantiate()	
	# station 2
	fire_bullet(bullet, Vector2(position.x - 11, position.y+ 6), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 1 and 9
	bullet = bullet_scene[0].instantiate()	
	fire_bullet(bullet, Vector2(position.x- 10, position.y), deg_to_rad(90))
	bullet = bullet_scene[0].instantiate()	
	fire_bullet(bullet, Vector2(position.x+11, position.y+6), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 8
	bullet = bullet_scene[1].instantiate()	
	fire_bullet(bullet, Vector2(position.x+12, position.y+5), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 3 and 5
	bullet = bullet_scene[2].instantiate()	
	fire_bullet(bullet, Vector2(position.x-12, position.y+5), deg_to_rad(90))
	bullet = bullet_scene[2].instantiate()	
	fire_bullet(bullet, Vector2(position.x-13, position.y+6), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 4 and 10
	bullet = bullet_scene[0].instantiate()	
	fire_bullet(bullet, Vector2(position.x-12, position.y), deg_to_rad(90))
	bullet = bullet_scene[0].instantiate()	
	fire_bullet(bullet, Vector2(position.x+10, position.y), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 6
	bullet = bullet_scene[1].instantiate()	
	fire_bullet(bullet, Vector2(position.x+13, position.y+6), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 7
	bullet = bullet_scene[1].instantiate()	
	fire_bullet(bullet, Vector2(position.x+12, position.y), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
