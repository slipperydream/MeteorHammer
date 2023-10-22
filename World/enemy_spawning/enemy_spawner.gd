extends Node2D

@export var title : String = ''
@export var waves : Array[Enemy_wave] = []
var stage_spawns : Array = []
@export var mid_boss : PackedScene 
@export var end_boss : Resource 
@onready var player = get_tree().get_first_node_in_group("player")
@onready var main = get_tree().get_first_node_in_group("main")
@onready var ui = get_tree().get_first_node_in_group("ui")
@onready var screensize : Vector2 = get_viewport_rect().size

var time = 0
var num_lanes : int = 7
var gutter_size : int = 30
var default_pos_y = -10
var spawn_count : int = 0
var total_enemies : int = 0
var all_spawned : bool = false

signal boss_spawned

func ready():
	pass

func build_spawns():
	for w in waves:
		for s in w.spawns:
			s.spawn_time = w.wave_start_time + s.spawn_time
			stage_spawns.append(s)
		
func get_spawn_position(lane):
	if lane > num_lanes-1 or lane < 0:
		lane = randi_range(0, num_lanes-1)
	var lane_size = (screensize.x - (2 * gutter_size)) / num_lanes	
	var pos_x = lane * lane_size + lane_size
	return Vector2(pos_x, default_pos_y)
	
func start():
	$Timer.start()
	boss_spawned.connect(main._on_boss_spawned)
	boss_spawned.connect(ui._on_boss_spawned)
	build_spawns()
	total_enemies = stage_spawns.size()	

func spawn_boss():
	spawn_enemy(end_boss, Vector2(screensize.x/2, default_pos_y), 80)
	emit_signal("boss_spawned")

func spawn_enemy(spawn, pos, screen_y):
	var new_enemy = spawn
	var enemy_spawn = new_enemy.instantiate()
	enemy_spawn.global_position = pos
	add_child(enemy_spawn)
	if enemy_spawn.is_GOB:
		enemy_spawn.global_position.y = screen_y
	enemy_spawn.start(enemy_spawn.global_position)
	enemy_spawn.died.connect(main._on_enemy_died)
	
func _on_timer_timeout():
	time += 1
	if all_spawned == false:
		for i in stage_spawns:
			if time >= i.spawn_time and i.spawned == false:
				spawn_enemy(i.spawn, get_spawn_position(i.lane), i.screen_y)
				i.spawned = true
				spawn_count += 1
		if spawn_count >= total_enemies:
			all_spawned = true
	else:
		$Timer.stop()
		spawn_boss()
				
func _on_main_game_over():
	queue_free()

