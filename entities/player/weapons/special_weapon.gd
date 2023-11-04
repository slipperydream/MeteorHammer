extends Resource

class_name Special_weapon

@export var name : String
@export var sprite : Texture2D
@export var weapon : PackedScene
@export_range(1, 30) var cost = 1
@export var description : String = ''
