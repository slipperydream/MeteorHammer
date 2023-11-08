extends Node2D

signal boss_spawned
signal stage_boss_spawned

@export var title : String = ''
@export var waves : Array[Enemy_wave] = []
@export var paths : Array[Path2D] = []

@onready var player = get_tree().get_first_node_in_group("player")
@onready var main = get_tree().get_first_node_in_group("main")
@onready var ui = get_tree().get_first_node_in_group("ui")
@onready var screensize : Vector2 = get_viewport_rect().size

var time = 0
var stage_enemies = []

func ready():
	self.connect(main.end_stage, _on_main_end_stage)
	self.connect(main.game_over, _on_main_game_over)
	
func start():
	for wave in waves:
		build_spawns(wave)
	$Timer.start()
	boss_spawned.connect(main._on_boss_spawned)
	boss_spawned.connect(ui._on_boss_spawned)

func build_spawns(wave):
	var index = 0
	for spawn_info in wave.spawns:
		spawn_info.spawn_time = wave.wave_start_time + wave.offset_time * index
		spawn_info.offset_x = index * wave.offset_x
		spawn_info.offset_y = index * wave.offset_y
		spawn_info.spawn_pt = wave.start_pt.position
		spawn_info.spawn_pt.x += spawn_info.offset_x
		spawn_info.spawn_pt.y += spawn_info.offset_y
		spawn_info.direction = wave.direction
		stage_enemies.append(spawn_info)
		index += 1
	
func spawn_enemy(spawn_info):
	var new_enemy = spawn_info.spawn
	var enemy = new_enemy.instantiate()
	enemy.died.connect(main._on_enemy_died)
	enemy.direction = spawn_info.direction
	
	if spawn_info.is_boss:
		emit_signal("boss_spawned")
		enemy.add_to_group("boss")
		#emit_signal("stage_boss_spawned")
						
	add_child(enemy)	
	enemy.start(spawn_info.spawn_pt)	

func _on_main_end_stage():
	queue_free()
				
func _on_main_game_over():
	queue_free()

func _on_timer_timeout():
	time += 0.5
	for enemy in stage_enemies:
		if time >= enemy.spawn_time and enemy.has_spawned == false:
			spawn_enemy(enemy)
			enemy.has_spawned = true

func _on_boss_spawned():
	$Background.stop()
