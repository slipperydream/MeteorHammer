extends Resource

class_name Bullet_pattern

@export var weapon : PackedScene
@export var weapon_size : Vector2 = Vector2(0.5, 0.5)
@export var velocity : int = 75
@export var direction : Vector2 = Vector2(0,1) # down
@export var position : Vector2 = Vector2(0,0)
@export var aimed : bool = false
@export var delay : float = 0.0
