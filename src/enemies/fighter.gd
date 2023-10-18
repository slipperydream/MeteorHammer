extends "res://src/enemies/enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
		bullet_scene = preload("res://scenes/enemies/enemy_bullet.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func shoot():
	for point in range(12):
		#shape more into a whip, 
		#or make a line2d to do that?
		var bullet = bullet_scene.instantiate()
		fire_bullet(bullet, position, deg_to_rad(point * 15))
		await get_tree().create_timer(0.1).timeout
