extends Node2D

@export var spawns : Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")
@onready var main = get_tree().get_first_node_in_group("main")
@onready var screensize : Vector2 = get_viewport_rect().size
@export var time = 0

var last_lane : int = 1
var gutter_size : int = 30
@export var num_lanes : int = 5
var pos_y = 5
var spawn_count : int = 0
var total_enemies : int = 0
var all_spawned : bool = false

signal boss_spawned

func ready():
	pass
	
func start():
	$Timer.start()
	var enemy_spawns = spawns
	for i in enemy_spawns:
		total_enemies += i.enemy_num
	
func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	if all_spawned == false:
		for i in enemy_spawns:
			if time >= i.spawn_time and i.spawned == false:
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_spawn_position()
					add_child(enemy_spawn)
					enemy_spawn.start(enemy_spawn.global_position)
					counter += 1
					enemy_spawn.died.connect(main._on_enemy_died)
					spawn_count += 1
					if enemy_spawn.is_boss:
						emit_signal("boss_spawned")
				i.spawned = true
		if spawn_count >= total_enemies:
			all_spawned = true
	else:
		$Timer.stop()
		

	
func get_spawn_position():
	var lane_size = (screensize.x - (2 * gutter_size)) / num_lanes
	
	if last_lane >= num_lanes:
		last_lane = 1
	var pos_x = last_lane * lane_size + gutter_size
	last_lane +=1 
	return Vector2(pos_x, pos_y)


func _on_main_start_game(_start_lives, _current_stage):
	start()

func _on_main_game_over():
	queue_free()
