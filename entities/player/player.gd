extends Node2D

class_name Player 

signal player_hit
signal died
signal out_of_lives
signal bomb_charging
signal bomb_recharged
signal bomb_used
signal special_selected
signal ammo_count
signal ammo_overstocked
signal no_ammo_error
signal bullet_cancelled

@export var base_speed : int = 2
@export var cooldown : float = 0.1
@export var main_weapon: PackedScene
@export var bomb_scene : PackedScene
@export var option_scene : PackedScene
@export var explosion_sound : AudioStreamWAV
@export var firing_stations : Array[Marker2D] = []

@onready var mech = $Mech
@onready var laser = $Laser
@onready var mech_config : Mech_configuration = load("res://entities/player/mechs/typeC.tres")
@onready var special_config : Special_weapon = load("res://entities/player/weapons/katana.tres")
@onready var bomb_config : Bomb_setting = load("res://entities/player/items/bs_balance.tres")

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var player_size : Vector2 = mech.texture.get_size()
@onready var bomb_timer = $BombTimer
@onready var gun_cooldown = $GunCooldown
@onready var invuln_timer = $InvulnerabilityTimer
@onready var targeting_component = $TargetingComponent
@onready var health_component : HealthComponent = $HealthComponent

var station_offset_x : int = 15
var station_offset_Y : int = 36
var speed : int
var ammo : int = 100
var can_shoot : bool = true
var assist_mode_enabled = false
var options = []

var option_index = Player_option.Option_Formation.FRONT
var default_health : int = 1
var lives : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.health = default_health

func start():
	reset()
	position = Vector2(screensize.x / 2, screensize.y - (player_size.y * 2))
	emit_signal("ammo_count", ammo)
	bomb_timer.start()
	emit_signal("bomb_charging", bomb_config.recharge_time)

func configure(in_mech_config, in_special_config, in_bomb_setting):
	mech_config = in_mech_config
	mech.modulate = mech_config.color
	speed = base_speed * mech_config.speed 
	laser.width = mech_config.laser_width
	laser.power = mech_config.laser_power
	
	set_firing_stations()
	
	bomb_config = in_bomb_setting
	bomb_timer.wait_time = 0.1
	var num_options = bomb_config.max_options
	configure_options(num_options)
	switch_option_formation()
	
	special_config = in_special_config
	emit_signal("special_selected", special_config.name)

func configure_options(num):
	for i in range(num):
		var option = option_scene.instantiate()
		option.option_num = i + 1
		add_child(option)
		options.append(option)
		
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
		mech.frame = 0
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
	for child in get_children():
		if child is Player_option:
			child.shoot()

func remove_bullets():
	get_tree().call_group("bullets", "queue_free")

func switch_option_formation():		
	option_index += 1
	
	if option_index >= Player_option.Option_Formation.size():
		option_index = Player_option.Option_Formation.FRONT
		
	for child in get_children():
		if child is Player_option:
			child.change_formation(option_index, global_position)
	
func use_bomb():	
	if bomb_timer.is_stopped():
		turn_invulnerable()
		var bomb = bomb_scene.instantiate()
		
		# debugger compalins about not using call_deferred,
		# but that breaks for me
		get_tree().root.add_child(bomb)
		bomb.position = position
		bomb.execute()
		emit_signal("bomb_used")
		health_component.bomb_available = false
		bomb_timer.wait_time = bomb_config.recharge_time
		bomb_timer.start()
		emit_signal("bomb_charging", bomb_config.recharge_time)
		return true
	else:
		print("waiting on bomb timer to recharge")
		return false
		
func _on_gun_cooldown_timeout():
	can_shoot = true
		
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
	health_component.bomb_available = true

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
		health_component.is_dead = false
	else:
		out_of_lives.emit()

func _on_pickup_area_area_entered(area):
	if area is Pickup:
		area.drifting = false

func _on_health_component_use_bomb():
	use_bomb()

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		var parent = area.get_parent()
		if parent is Enemy:
			# no cheap kills for now
			if health_component.invulnerable:
				return
			area.take_damage(50, DamageConstants.DamageTypes.COLLISION)
			health_component.take_damage(1, DamageConstants.DamageTypes.COLLISION)
		elif parent is Enemy_weapon and parent.is_cancelled:
			emit_signal("bullet_cancelled")
			parent.remove()
	if area is Pickup:
		area.execute()
		
func add_ammo(value):
	if ammo < 100:
		ammo += value
		ammo = min(ammo, 100)
		emit_signal("ammo_count", ammo)
	else:
		emit_signal("ammo_overstocked")

func _on_ammo_resupply(value):
	add_ammo(value)
		
