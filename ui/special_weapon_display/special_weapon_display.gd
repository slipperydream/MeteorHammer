extends Control


@onready var player = get_tree().get_first_node_in_group("player")
@onready var image = $Img
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect(player.special_selected, _on_player_special_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

