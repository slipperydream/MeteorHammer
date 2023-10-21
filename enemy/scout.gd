extends "res://enemy/shooting_enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/spinning_bullet.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$Sprite2D/Boosters.animation = "forward"

func shoot():
	var spacing = enemy_size.x / 3
	# firing at the sides of the ship
	var bullet = bullet_scene[0].instantiate()
	fire_bullet(bullet, Vector2(position.x - spacing, position.y), deg_to_rad(90))
	bullet = bullet_scene[0].instantiate()
	fire_bullet(bullet, Vector2(position.x + spacing, position.y), deg_to_rad(90))
	await get_tree().create_timer(0.2).timeout
