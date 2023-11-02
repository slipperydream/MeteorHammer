extends Resource

class_name Spawn_info

@export var spawn : Resource
@export_range(0,6) var lane : int
@export_range(-200,650) var screen_y : int = -64
@export_range(0,50) var extra_speed : int = 0
var has_spawned : bool = false
var is_boss : bool = false
var path : int = -1
var spawn_time : int = 0
