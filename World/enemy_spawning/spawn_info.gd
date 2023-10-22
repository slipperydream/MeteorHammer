extends Resource

class_name Spawn_info

@export_range(0,120) var spawn_time : int
var spawned : bool = false
@export var spawn : Resource
@export_range(0,6) var lane : int
@export var spawn_on_screen : bool = false
@export_range(10,300) var screen_y : int = 200
