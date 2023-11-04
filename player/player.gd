extends Area2D

class_name Player 

signal player_hit
signal died
signal out_of_lives
signal bomb_charging
signal bomb_recharged
signal bomb_used
signal special_selected
signal ammo_count
signal no_ammo_error

@export var base_speed : int = 2
@export var cooldown : float = 0.1
@export var main_weapon: PackedScene
@export var bomb_scene : PackedScene
@export var explosion_sound : AudioStreamWAV
@export var firing_stations : Array[Marker2D] = []

@onready var mech = $Mech
@onready var laser = $Laser
@onready var mech_config : Mech_configuration = load("res://player/mechs/typeC.tres")
@onready var special_config : Special_weapon = load("res://player/weapons/katana.tres")
@onready var bomb_config : Bomb_setting = load("res://player/items/bs_balance.tres")

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var player_size : Vector2 = mech.texture.get_size()
@onready var bomb_timer = $BombTimer
@onready var gun_cooldown = $GunCooldown
@onready var invuln_timer = $InvulnerabilityTimer
@onready var left_option = $Mech/LeftOption
@onready var right_option = $Mech/RightOption
@onready var targeting_component = $TargetingComponent
@onready var health_component : HealthComponent = $HealthComponent

var station_offset_x : int = 15
var station_offset_Y : int = 36
var speed : int
var ammo : int = 100
var can_shoot : bool = true
var assist_mode_enabled = false
enum Option_Formation { SPREAD, TAIL, SIDES, FRONT}
var option_index = Option_Formation.FRONT
var default_health : int = 1
var lives : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.health = default_health

func start():
	reset()
	position = Vector2(screensize.x / 2, screensize.y - (player_size.y * 4))
	emit_signal("ammo_count", ammo)
	bomb_timer.start()
	emit_signal("bomb_charging", bomb_config.recharge_time)

func configure(in_mech_config, in_special_config, in_bomb_setting):
	mech_config = in_mech_config
	mech.texture = mech_config.sprite
	speed = base_speed * mech_config.speed 
	laser.width = mech_config.laser_width
	laser.power = mech_config.laser_power
	
	set_firing_stations()
	
	bomb_config = in_bomb_setting
	bomb_timer.wait_time = 0.1
	switch_option_formation()
	
	special_config = in_special_config
	emit_signal("special_selected", special_config.name)
	
func set_firing_stations():
	var i = 0
	while i < firing_stations.size():
		firing_stations[i].start(Vector2(global_position.x - station_offset_x + (i * mech_config.spacing), global_position.y - station_offset_Y))
		firing_stations[i].angle = mech_config.start_angle + (i * mech_config.canting)
		i += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input.x > 0:
		mech.frame = 3
		get_tree().call_group("option", "move", "right")
	elif input.x < 0:
		mech.frame = 1
		get_tree().call_group("option", "move", "left")
	else:
		mech.frame = 2
		get_tree().call_group("option", "move", "forward")
	position += input * speed * delta
	position = position.clamp(Vector2(64,64), screensize - Vector2(64,64))
	
	if Input.is_action_pressed("main_weapon_fire"):
		main_weapon_fire()
	elif Input.is_action_pressed("laser"):
		laser.start()
		speed -= 15
		speed = max(base_speed * mech_config.speed * 0.75, speed)
	if Input.is_action_just_released("laser"):
		laser.stop()
		speed = base_speed * mech_config.speed 
	if Input.is_action_just_pressed("special_weapon_fire"):
		special_weapon_fire()
	
	if assist_mode_enabled:
		if Input.is_action_just_pressed("assist_mode_fire"):
			options_fire()
		
func _input(event):	
	if event.is_action_pressed("use_bomb"):
		use_bomb()
	if event.is_action_pressed("switch_formation"):
		switch_option_formation()
		
func turn_invulnerable():
	health_component.set_invulnerability(true)
	$AnimationPlayer.play("invlunerable")
	invuln_timer.start()	
			
func reset():
	gun_cooldown.wait_time = cooldown
	if not visible:
		show()
	can_shoot = true

func special_weapon_fire():	
	var cost = special_config.cost
	if ammo - cost < 0:
		emit_signal("no_ammo_error")
		return
	else:
		ammo -= cost
		emit_signal("ammo_count", ammo)
		
	var weapon = special_config.weapon.instantiate()
	get_tree().root.add_child(weapon)
	if weapon.title.to_lower() == "mine":
		weapon.start(global_position + Vector2(0, 64), Vector2.DOWN.rotated(rotation))
	elif weapon.title.to_lower().contains("katana"):
		weapon.start(global_position + Vector2(0, -300))
	elif weapon.title.to_lower().contains("missile"):
		var target = targeting_component.acquire_target(global_position, "enemy")
		weapon.start(global_transform, target)
		await get_tree().create_timer(0.1).timeout
		for i in range(3):
			weapon = special_config.weapon.instantiate()
			get_tree().root.add_child(weapon)
			target = targeting_component.acquire_target(global_position, "enemy")
			weapon.start(global_transform, target)
			await get_tree().create_timer(0.1).timeout
		
	if not assist_mode_enabled:
		options_fire()
		
func main_weapon_fire():
	if can_shoot == false:
		return
	can_shoot = false
	gun_cooldown.start()
	for i in firing_stations:
		var weapon = main_weapon.instantiate()
		get_tree().root.add_child(weapon)
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
		option_index = Option_Formation.SPREAD

	match option_index:
		Option_Formation.SPREAD:
			left_option.global_position.x = global_position.x - player_size.x/4
			left_option.global_position.y = global_position.y + (player_size.y/8)
			left_option.set_rotation_degrees(-15)
			left_option.firing_angle = 75
			
			right_option.global_position.x = global_position.x + player_size.x/4
			right_option.global_position.y = global_position.y + (player_size.y/8)
			right_option.set_rotation_degrees(15)
			right_option.firing_angle = 105
		Option_Formation.TAIL:
			left_option.global_position.x = global_position.x - (player_size.x/8)
			left_option.global_position.y = global_position.y + player_size.y
			left_option.set_rotation_degrees(-180)
			left_option.firing_angle = 270
		
			right_option.global_position.x = global_position.x + (player_size.x/8)
			right_option.global_position.y = global_position.y + player_size.y
			right_option.set_rotation_degrees(180)
			right_option.firing_angle = 270
		Option_Formation.FRONT:
			left_option.global_position.x = global_position.x - (player_size.x/5)
			left_option.global_position.y = global_position.y - (player_size.y/2)
			left_option.set_rotation_degrees(0)
			left_option.firing_angle = 90
		
			right_option.global_position.x = global_position.x + (player_size.x/5)
			right_option.global_position.y = global_position.y - (player_size.y/2)
			right_option.set_rotation_degrees(0)
			right_option.firing_angle = 90
		Option_Formation.SIDES:
			left_option.global_position.x = global_position.x - (player_size.x/3)
			left_option.global_position.y = global_position.y 
			left_option.set_rotation_degrees(-90)
			left_option.firing_angle = 0
		
			right_option.global_position.x = global_position.x + (player_size.x/3)
			right_option.global_position.y = global_position.y
			right_option.set_rotation_degrees(90)
			right_option.firing_angle = 180

func take_damage(power, source=null):
	health_component.take_damage(power, source)
	
func use_bomb():	
	if bomb_timer.is_stopped():
		turn_invulnerable()
		var bomb = bomb_scene.instantiate()
		
		# debugger compalins about not using call_deferred,
		# but that breaks for me
		get_tree().root.add_child(bomb)
		
		bomb.execute(position)
		emit_signal("bomb_used")
		bomb_timer.wait_time = bomb_config.recharge_time
		bomb_timer.start()
		emit_signal("bomb_charging", bomb_config.recharge_time)
		return true
	else:
		print("waiting on bomb timer to recharge")
		return false
		
func _on_gun_cooldown_timeout():
	can_shoot = true
	
func _on_area_entered(area):
	if area is Enemy:
		area.take_damage(50, DamageConstants.DamageTypes.COLLISION)
		health_component.take_damage(1)
		
func _on_main_set_lives(num_lives):
	remove_bullets()
	lives = num_lives
	reset()

func _on_invulnerability_timer_timeout():
	$AnimationPlayer.stop()
	health_component.set_invulnerability(false)

func _on_main_end_stage(_current, _results):
	remove_bullets()
	hide()

func _on_bomb_timer_timeout():
	emit_signal("bomb_recharged")

func _on_health_component_hit():
	emit_signal("player_hit")

func _on_health_component_killed(_source):
	turn_invulnerable()
	remove_bullets()
	AudioStreamManager.play(explosion_sound.resource_path)
	emit_signal("died")
	lives = max(0, lives -1)
	if lives > 0:
		health_component.health = 1
	else:
		out_of_lives.emit()
