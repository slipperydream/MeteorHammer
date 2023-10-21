extends "res://enemy/base_enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/shell.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$Sprite2D/Boosters.animation = "forward"

func shoot():
	var spacing = enemy_size.x / 3
	
	# firing six shots in bursts of 2, moving outwards from the chassis
	for shot in range(3):
		var bullet = bullet_scene[0].instantiate()
		fire_bullet(bullet, Vector2(position.x - (spacing + (shot * 10)), position.y), deg_to_rad(90))
		bullet = bullet_scene[0].instantiate()
		fire_bullet(bullet, Vector2(position.x + (spacing + (shot * 10)), position.y), deg_to_rad(90))
		await get_tree().create_timer(0.2).timeout
