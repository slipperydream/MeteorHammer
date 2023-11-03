extends Resource

class_name Enemy_wave

@export var is_boss_wave : bool = false
@export var wave_start_time : int = 0
@export var start_pt : Vector2 = Vector2(300, -64)
@export var path : int = 0
@export var spawn_size : int = 64
@export var spawns : Array[Spawn_info] = []
var has_spawned : bool = false

