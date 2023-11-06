extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	var color = SettingsManager.get_bullet_color()
	update_color(color)
	


func update_color(color):
	$Sprite2D.modulate = color
	$Sprite2D2.modulate = color
	$Sprite2D3.modulate = color
	$Sprite2D4.modulate = color

func _on_bullet_color_setting_bullet_color_changed(color):
	update_color(color)


func _on_visibility_changed():
	if visible:
		$AnimationPlayer.play("move_bullet")
	else:
		$AnimationPlayer.stop()
