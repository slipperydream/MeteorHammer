extends "res://player/items/base_item.gd"

@export var blast_radius : int = 150
@export var power : int = 5
var targets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = blast_radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func execute(pos):
	super.execute(pos)
	self.visible = true
	position = pos
	$AnimationPlayer.play("explode")
	var potential_targets = get_tree().get_nodes_in_group("enemy")
	for tgt in potential_targets:
		var tgt_pos = tgt.position
		var dis = tgt_pos.distance_to(position) 
		if dis < blast_radius:
			tgt.take_damage(power)
	
