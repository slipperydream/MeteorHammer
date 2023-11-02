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

func ready():
	self.connect(main.end_stage, _on_main_end_stage)
	self.connect(main.game_over, _on_main_game_over)
	
func start():
	new_background.connect(main._on_new_background)
	emit_signal("new_background", background)
	# give the player a few seconds to fly around before the level actually starts
	await get_tree().create_timer(2).timeout
	$Timer.start()
	boss_spawned.connect(main._on_boss_spawned)
	boss_spawned.connect(ui._on_boss_spawned)

func spawn_wave(wave):
	var num_spawns = wave.spawns.size()
	var index = 0
	for spawn in wave.spawns:
		spawn.offset_x = index * wave.spawn_size
		spawn.offset_y = index * wave.spawn_size
		spawn.spawn_pt = wave.start_pt
		spawn.spawn_pt.x += spawn.offset_x
		spawn.spawn_pt.y += spawn.offset_y
		
		spawn.path = wave.path
		spawn_enemy(spawn)	
	
func spawn_enemy(spawn_info):
	var new_enemy = spawn_info.spawn
	var enemy_spawn = new_enemy.instantiate()
	enemy_spawn.died.connect(main._on_enemy_died)
	if spawn_info.is_boss:
		emit_signal("boss_spawned")
		enemy_spawn.add_to_group("boss")
		#emit_signal("stage_boss_spawned")
			
	enemy_spawn.global_position = spawn_info.spawn_pt
	add_child(enemy_spawn)
	if enemy_spawn.path:
		for pt in enemy_spawn.path:
			pt.x += spawn_info.offset_x
			pt.y += spawn_info.offset_y
			
	enemy_spawn.start(enemy_spawn.global_position)	

func _on_main_end_stage():
	queue_free()
				
func _on_main_game_over():
	queue_free()

func _on_timer_timeout():
	time += 1
	for wave in waves:
		if time >= wave.wave_start_time and wave.has_spawned == false:
			spawn_wave(wave)
			wave.has_spawned = true
		
	
