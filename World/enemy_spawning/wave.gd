extends Resource

class_name Enemy_wave

@export var is_boss_wave : bool = false
@export var wave_start_time : int = 0
@export var start_pt : Marker2D
@export var offset_x : int = 0
@export var offset_y : int = 0
@export var direction : Vector2 = Vector2(0,1)
@export var path : int = -1
@export var spawns : Array[Spawn_info] = []
var has_spawned : bool = false

