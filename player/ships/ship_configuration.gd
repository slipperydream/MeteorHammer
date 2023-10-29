extends Resource

class_name Ship_configuration

@export var name : String
@export var sprite : Texture2D
@export_range(50, 100) var speed : int = 75
@export_range(50, 100) var shot_width : float = 75
@export var description : String = ''

@export var spacing : int = 15
@export var start_angle : int = 75
@export var canting : int = 5
