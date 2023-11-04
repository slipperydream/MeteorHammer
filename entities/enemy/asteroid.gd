extends "res://entities/enemy/base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	var start_frame = randi_range(0,3)
	$Sprite2D.frame = start_frame * 4
	match start_frame:
		0: $AnimationPlayer.play("moveA")
		1: $AnimationPlayer.play("moveB")
		2: $AnimationPlayer.play("moveC")
		3: $AnimationPlayer.play("moveD")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
