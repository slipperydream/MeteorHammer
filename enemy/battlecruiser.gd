extends "res://enemy/base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene = preload("res://enemy/weapons/enemy_beam.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$Sprite2D/Boosters.animation = "forward"

func shoot():
	super.shoot()
	return
	# Craziness is to get it to mostly match the animation
	var width = $Sprite2D.get_rect().size.x
	var height = $Sprite2D.get_rect().size.y
	$AnimationPlayer.play("shooting")
	var bullet = bullet_scene.instantiate()	
	# station 2
	fire_bullet(bullet, Vector2(position.x-(width/11), position.y+(height/6)), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 1 and 9
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x-(width/10), position.y), deg_to_rad(90))
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x+(width/11), position.y+(height/6)), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 8
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x+(width/12), position.y+(height/5)), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 3 and 5
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x-(width/12), position.y+(height/5)), deg_to_rad(90))
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x-(width/13), position.y+(height/6)), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 4 and 10
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x-(width/12), position.y), deg_to_rad(90))
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x+(width/10), position.y), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 6
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x+(width/13), position.y+(height/6)), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
	
	#station 7
	bullet = bullet_scene.instantiate()	
	fire_bullet(bullet, Vector2(position.x+(width/12), position.y), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
