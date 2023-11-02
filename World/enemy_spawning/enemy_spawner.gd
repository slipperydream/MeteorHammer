extends Node2D

signal new_background
signal boss_spawned
signal stage_boss_spawned

@export var title : String = ''
@export var waves : Array[Enemy_wave] = []
@export var paths : Array[Path2D] = []
@export var background : Texture

@onready var player = get_tree().get_first_node_in_group("player")
@onready var main = get_tree().get_first_node_in_group("main")
@onready var ui = get_tree().get_first_node_in_group("ui")
@onready var screensize : Vector2 = get_viewport_rect().size

var time = 0
var num_lanes : int = 7
var gutter_size : int = 30
var stage_spawns : Array = []

func ready():
	self.connect(main.end_stage, _on_main_end_stage)
	self.connect(main.game_over, _on_main_game_over)

func build_spawns():
	for w in waves:
		get_tree().create_timer(w.wave_start_time).timeout
		for s in w.spawns:		
			if w.is_boss_wave:
				s.is_boss = true
			if w.path >= 0:
				s.path = w.path
			stage_spawns.append(s)
		spawn_wave()

func spawn_wave():
	for spawn in stage_spawns:
		if spawn.has_spawned == false:
			spawn_enemy(spawn)
			spawn.has_spawned = true

func get_position_x(lane):
	if lane > num_lanes-1 or lane < 0:
		lane = randi_range(0, num_lanes-1)
	var lane_size = (screensize.x - (2 * gutter_size)) / num_lanes	
	var pos_x = lane * lane_size + lane_size
	return pos_x
	
func start():
	new_background.connect(main._on_new_background)
	emit_signal("new_background", background)
	# give the player a few seconds to fly around before the level actually starts
	await get_tree().create_timer(2).timeout
	boss_spawned.connect(main._on_boss_spawned)
	boss_spawned.connect(ui._on_boss_spawned)
	build_spawns()

func spawn_enemy(spawn_info):
	var new_enemy = spawn_info.spawn
	var enemy_spawn = new_enemy.instantiate()
	enemy_spawn.speed += spawn_info.extra_speed
	enemy_spawn.died.connect(main._on_enemy_died)
	if spawn_info.is_boss:
		emit_signal("boss_spawned")
		enemy_spawn.add_to_group("boss")
		#emit_signal("stage_boss_spawned")
			
	if spawn_info.path >= 0:
		var follow = PathFollow2D.new()
		follow.loop = false
		follow.rotates = false
		paths[spawn_info.path].add_child(follow)
		follow.add_child(enemy_spawn)
	else:
		enemy_spawn.global_position.x = get_position_x(spawn_info.lane)
		enemy_spawn.global_position.y = spawn_info.screen_y
		add_child(enemy_spawn)
		
		enemy_spawn.start(enemy_spawn.global_position)	

func _on_main_end_stage():
	queue_free()
				
func _on_main_game_over():
	queue_free()

