extends Label

class_name Points_label

@export var lifetime : float = 1.5
# Called when the node enters the scene tree for the first time.
func _ready():
	show()

func display(pos, points, bonus):
	global_position = pos
	text = "+%d Points" % (points + bonus)
	if bonus >= (points / 2):
		add_theme_color_override("font_color", Color.GREEN)
	elif bonus >= (points/3):
		add_theme_color_override("font_color", Color.ORANGE)
	else:
		add_theme_color_override("font_color", Color.YELLOW)
	await get_tree().create_timer(lifetime).timeout
	hide()
	queue_free()
