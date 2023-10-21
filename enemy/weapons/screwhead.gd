extends "res://enemy/weapons/bullet.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if animate and $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("spin")
