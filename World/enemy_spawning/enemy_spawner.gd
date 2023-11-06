extends Node2D

signal new_background
signal boss_spawned
signal stage_boss_spawned

@export var title : String = ''
@export var waves : Array[Enemy_wave] = []
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
	$Timer.start()
	boss_spawned.connect(main._on_boss_spawned)
	boss_spawned.connect(ui._on_boss_spawned)

func spawn_wave(wave):
	var index = 0
	for spawn_info in wave.spawns:
		spawn_info.offset_x = index * wave.offset_x
		spawn_info.offset_y = index * wave.offset_y
		spawn_info.spawn_pt = wave.start_pt.position
		spawn_info.spawn_pt.x += spawn_info.offset_x
		spawn_info.spawn_pt.y += spawn_info.offset_y
		spawn_info.direction = wave.direction
		spawn_enemy(spawn_info)	
		index += 1
	
func spawn_enemy(spawn_info):
	var new_enemy = spawn_info.spawn
	var enemy_spawn = new_enemy.instantiate()
	enemy_spawn.died.connect(main._on_enemy_died)
	enemy_spawn.direction = spawn_info.direction
	add_child(enemy_spawn)
	if spawn_info.is_boss:
		emit_signal("boss_spawned")
		enemy_spawn.add_to_group("boss")
		#emit_signal("stage_boss_spawned")
						
	enemy_spawn.start(spawn_info.spawn_pt)	

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
		
	
