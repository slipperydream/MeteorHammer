extends Area2D

signal died
signal out_of_lives
signal gained_life
signal bomb_charging
signal bomb_recharged
signal bomb_used
signal weapon_changed
signal player_hit

var lives = 3

@export var base_speed : int = 150
@export var cooldown : float = 0.1
@export var bomb_recharge_time : float = 20.0
@export var main_weapon: PackedScene
@export var special_weapon : PackedScene
@onready var config : Ship_configuration = load("res://player/ships/typeC.tres")
@export var bomb_scene : PackedScene
@export var explosion_sound : AudioStreamWAV
@export var firing_stations : Array[Firing_station] = []
@export var x_offset : int = 20
@export var y_offset : int = 24

var speed : int
var can_shoot : bool = true
var invulnerable : bool = false
var assist_mode_enabled = false
enum Option_Formation { SPREAD, TAIL, SIDES, FRONT}
var option_index = Option_Formation.FRONT

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : Vector2 = $Ship.texture.get_size()
@onready var bomb_timer = $BombTimer
@onready var gun_cooldown = $GunCooldown
@onready var invuln_timer = $InvulnerabilityTimer
@onready var left_option = $Ship/LeftOption
@onready var right_option = $Ship/RightOption

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	$Ship.texture = config.sprite
	speed = base_speed * (config.speed * 1.5 / 100)
	emit_signal("weapon_changed", "beam")
	position = Vector2(screensize.x / 2, screensize.y - (shipsize.y * 4))
	set_firing_stations(5)
	switch_option_formation()

func set_firing_stations(value):
	var i = 0
	while i < firing_stations.size():
		firing_stations[i].start(Vector2(global_position.x - x_offset + (i * config.spacing), global_position.y - y_offset))
		print("sfs ship %v" % global_position)
		print("sfs station %v" % firing_stations[i].global_position)
		firing_stations[i].angle = config.start_angle + (i * config.canting)
		i += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input.x > 0:
		$Ship.frame = 2
		get_tree().call_group("option", "move", "right")
		$Ship/LeftBooster.animation = "right"
		$Ship/RightBooster.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/LeftBooster.animation = "left"
		$Ship/RightBooster.animation = "left"
		get_tree().call_group("option", "move", "left")
	else:
		$Ship.frame = 1
		get_tree().call_group("option", "move", "forward")
		$Ship/LeftBooster.animation = "forward"
		$Ship/RightBooster.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(64,64), screensize - Vector2(64,64))
	
	if Input.is_action_pressed("main_weapon_fire"):
		main_weapon_fire()
	elif Input.is_action_just_pressed("special_weapon_fire"):
		special_weapon_fire()
	
	if assist_mode_enabled:
		if Input.is_action_just_pressed("assist_mode_fire"):
			options_fire()
		
func _input(event):	
	if event.is_action_pressed("use_bomb"):
		use_bomb()
	if event.is_action_pressed("switch_formation"):
		switch_option_formation()
		
func make_invulnerable():
	invulnerable = true
	$AnimationPlayer.play("invlunerable")
	invuln_timer.start()	
			
func reset():
	gun_cooldown.wait_time = cooldown
	if not visible:
		show()
	can_shoot = true

func special_weapon_fire():	
	if can_shoot == false:
		return
	can_shoot = false
	gun_cooldown.start()	
	var weapon = special_weapon.instantiate()
	get_tree().root.add_child(weapon)
	var angle = deg_to_rad(90)
	weapon.start(position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))	
	if not assist_mode_enabled:
		options_fire()
		
func main_weapon_fire():
	if can_shoot == false:
		return
	can_shoot = false
	gun_cooldown.start()
	var width = 0
	for i in firing_stations:
		var weapon = main_weapon.instantiate()
		get_tree().root.add_child(weapon)
		print("station %v" % i.global_position)
		print(global_position)
		weapon.start(i.global_position, Vector2.RIGHT.rotated(deg_to_rad(i.angle)), i.angle)	
	if not assist_mode_enabled:
		options_fire()

func options_fire():
	left_option.shoot()
	right_option.shoot()		

func remove_bullets():
	get_tree().call_group("bullets", "queue_free")

func switch_option_formation():		
	option_index += 1
	if option_index >= Option_Formation.size():
		option_index = 0

	match option_index:
		Option_Formation.SPREAD:
			left_option.global_position.x = global_position.x - shipsize.x/4
			left_option.global_position.y = global_position.y + (shipsize.y/8)
			left_option.set_rotation_degrees(-15)
			left_option.firing_angle = 75
			
			right_option.global_position.x = global_position.x + shipsize.x/4
			right_option.global_position.y = global_position.y + (shipsize.y/8)
			right_option.set_rotation_degrees(15)
			right_option.firing_angle = 105
		Option_Formation.TAIL:
			left_option.global_position.x = global_position.x - (shipsize.x/8)
			left_option.global_position.y = global_position.y + shipsize.y
			left_option.set_rotation_degrees(-180)
			left_option.firing_angle = 270
		
			right_option.global_position.x = global_position.x + (shipsize.x/8)
			right_option.global_position.y = global_position.y + shipsize.y
			right_option.set_rotation_degrees(180)
			right_option.firing_angle = 270
		Option_Formation.FRONT:
			left_option.global_position.x = global_position.x - (shipsize.x/5)
			left_option.global_position.y = global_position.y - (shipsize.y/2)
			left_option.set_rotation_degrees(0)
			left_option.firing_angle = 90
		
			right_option.global_position.x = global_position.x + (shipsize.x/5)
			right_option.global_position.y = global_position.y - (shipsize.y/2)
			right_option.set_rotation_degrees(0)
			right_option.firing_angle = 90
		Option_Formation.SIDES:
			left_option.global_position.x = global_position.x - (shipsize.x/3)
			left_option.global_position.y = global_position.y 
			left_option.set_rotation_degrees(-90)
			left_option.firing_angle = 0
		
			right_option.global_position.x = global_position.x + (shipsize.x/3)
			right_option.global_position.y = global_position.y
			right_option.set_rotation_degrees(90)
			right_option.firing_angle = 180
			
func take_damage(_value):
	emit_signal("player_hit")
	
	if invulnerable: 
		return
		
	if bomb_timer.is_stopped():
		use_bomb()
		return
		
	lives = max(0, lives - 1)
	if lives > 0:
		died.emit()
		remove_bullets()
		AudioStreamManager.play(explosion_sound.resource_path)
		make_invulnerable()	
	else:
		remove_bullets()
		out_of_lives.emit()
	
func use_bomb():	
	if bomb_timer.is_stopped():
		make_invulnerable()
		var item = bomb_scene.instantiate()
		get_tree().root.add_child(item)
		item.execute(position)
		emit_signal("bomb_used")
		bomb_timer.wait_time = bomb_recharge_time
		bomb_timer.start()
		emit_signal("bomb_charging")
	else:
		print("waiting on item timer to recharge")
		
func _on_gun_cooldown_timeout():
	can_shoot = true
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.explode()
		take_damage(1)
		
func _on_main_player_start(num_lives, _credits):
	remove_bullets()
	lives = num_lives
	reset()
	bomb_timer.wait_time = bomb_recharge_time
	bomb_timer.start()
	emit_signal("bomb_charging")

func _on_invulnerability_timer_timeout():
	$AnimationPlayer.stop()
	invulnerable = false

func _on_main_end_stage(_current, _results):
	remove_bullets()
	hide()

func _on_bomb_timer_timeout():
	emit_signal("bomb_recharged")
