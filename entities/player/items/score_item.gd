extends Pickup

class_name Score_item

signal score_item_collected

@export_range(200,10000) var amount : int = 500

@onready var main = get_tree().get_first_node_in_group("main")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func execute():
	super.execute()
	if main.is_connected("score_item_collected", main._on_score_item_collected):
		emit_signal("score_item_collected", amount)
	else:
		self.connect("score_item_collected", main._on_score_item_collected)
		emit_signal("score_item_collected", amount)
	queue_free()
