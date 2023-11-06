extends Resource

class_name Mech_configuration

@export var name : String
@export var color : Color
@export_range(50, 100) var speed : int = 75
@export_range(50, 100) var shot_width : float = 75
@export_range(20, 60) var laser_width : float = 35
@export_range(1, 20) var laser_power : float = 1
@export var description : String = ''

@export var spacing : int = 15
@export var start_angle : int = 75
@export var canting : int = 5
