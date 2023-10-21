extends "res://enemy/base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	var start = randi_range(0,3)
	$Sprite2D.frame = start * 4
	match start:
		0: $AnimationPlayer.play("moveA")
		1: $AnimationPlayer.play("moveB")
		2: $AnimationPlayer.play("moveC")
		3: $AnimationPlayer.play("moveD")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
