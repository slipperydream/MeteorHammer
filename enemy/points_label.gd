extends Label

class_name Points_label

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
#	display(global_position, 5)

func display(pos, points):
	global_position = pos
	text = "+%d Pts" % points

func _on_timer_timeout():
	hide()
	queue_free()
