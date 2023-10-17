extends "res://src/enemies/enemy_base_weapon.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("moving")
	var tween = create_tween()
	tween.tween_property(Sprite2D, "scale.y", 4, 0.25)

