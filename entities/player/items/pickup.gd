extends "res://entities/player/items/base_item.gd"

class_name Pickup

@export var direction : Vector2 = Vector2(0, 1)
@export var speed : int = 30

@onready var player = get_tree().get_first_node_in_group("player")

var drifting : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drifting:
		position = position + speed * delta * direction
	else:
		# move towards the player
		position += (player.position - position).normalized() * speed * delta

func start(pos):
	position = pos
	
func execute():
	super.execute()
	# need to rework so this works in multiplayer
	
func _on_area_entered(area):
	if area is HitboxComponent:
		execute()
