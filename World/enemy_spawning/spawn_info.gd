extends Resource

class_name Spawn_info

@export_range(0,10) var spawn_time : int
@export var spawn : Resource
@export_range(0,6) var lane : int
@export var spawn_on_screen : bool = false
@export_range(10,300) var screen_y : int = 200
@export_range(0,50) var extra_speed : int = 0
var spawned : bool = false
var is_boss : bool = false
var path : int = -1
