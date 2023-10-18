extends Area2D

enum pattern {WALL, LINE, LEFT_WALL, RIGHT_WALL, STAGGERED, DIAGONAL_LEFT, DIAGONAL_RIGHT, BOSS}

@export var enemy : PackedScene
@export var number : int = 9
@export var spawn_pattern : pattern
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
