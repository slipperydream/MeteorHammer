extends Resource

class_name Special_weapon

@export var name : String
@export var sprite : Texture2D
@export var weapon : PackedScene
@export_range(0.01, 5) var wait_time = 1.0
@export var description : String = ''
