extends Area2D

@export var weapon : PackedScene
var firing_angle : float = 90

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
