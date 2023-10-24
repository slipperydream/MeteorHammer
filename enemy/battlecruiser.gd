extends "res://enemy/shooting_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$Sprite2D/Boosters.animation = "forward"

