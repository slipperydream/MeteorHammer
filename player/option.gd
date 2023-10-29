extends Area2D

@export var weapon : PackedScene
var firing_angle : float = 90

func shoot():
	var wpn = weapon.instantiate()
	get_tree().root.add_child(wpn)	
	wpn.start(global_position, Vector2.RIGHT.rotated(deg_to_rad(firing_angle)), firing_angle)	

func move(dir):
	match dir:
		"left":
			$Sprite2D.frame = 1
		"right":
			$Sprite2D.frame = 2
		"forward":
			$Sprite2D.frame = 0
