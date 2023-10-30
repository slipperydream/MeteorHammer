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

@export var base_speed : int = 2
@export var cooldown : float = 0.1
@export var main_weapon: PackedScene
@export var bomb_scene : PackedScene
@export var explosion_sound : AudioStreamWAV
@export var firing_stations : Array[Marker2D] = []

@onready var ship_config : Ship_configuration = load("res://player/ships/typeC.tres")
@onready var special_config : Special_weapon = load("res://player/weapons/katana.tres")
@onready var bomb_config : Bomb_setting = load("res://player/items/bs_balance.tres")

var x_offset : int = 20
var y_offset : int = 24
var speed : int
var max_bombs : int
var bombs : int 
var can_shoot : bool = true
var special_available : bool = false
var invulnerable : bool = false
var assist_mode_enabled = false
enum Option_Formation { SPREAD, TAIL, SIDES, FRONT}
var option_index = Option_Formation.FRONT

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : Vector2 = $Ship.texture.get_size()
@onready var bomb_timer = $BombTimer
@onready var gun_cooldown = $GunCooldown
@onready var special_cooldown = $SpecialWeaponTimer
@onready var invuln_timer = $InvulnerabilityTimer
@onready var left_option = $Ship/LeftOption
@onready var right_option = $Ship/RightOption

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start():
	reset()
	position = Vector2(screensize.x / 2, screensize.y - (shipsize.y * 4))
	special_cooldown.start()
	emit_signal("weapon_changed", special_config.name)
	bomb_timer.start()
	emit_signal("bomb_charging", bomb_config.recharge_time)

func configure(in_ship_config, in_special_config, in_bomb_setting):
	ship_config = in_ship_config
	$Ship.texture = ship_config.sprite
	speed = base_speed * ship_config.speed 
	$Laser.width = ship_config.laser_width
	$Laser.power = ship_config.laser_power
	
	set_firing_stations()
	
	bomb_config = in_bomb_setting
	bomb_timer.wait_time = 0.1
	switch_option_formation()
	
	special_config = in_special_config
	special_cooldown.wait_time = special_config.wait_time
	
func set_firing_stations():
	var i = 0
	while i < firing_stations.size():
		firing_stations[i].start(Vector2(global_position.x - x_offset + (i * ship_config.spacing), global_position.y - y_offset))
		firing_stations[i].angle = ship_config.start_angle + (i * ship_config.canting)
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
	elif Input.is_action_pressed("laser"):
		$Laser.start()
	if Input.is_action_just_released("laser"):
		$Laser.stop()
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
	if special_available == false:
		return
	special_available = false
	special_cooldown.start()	
	var weapon = special_config.weapon.instantiate()
	get_tree().root.add_child(weapon)
	if weapon.title.to_lower() == "mine":
		weapon.start(global_position + Vector2(0, 64), Vector2.DOWN.rotated(rotation))
	elif weapon.title.to_lower().contains("katana"):
		weapon.start(global_position + Vector2(0, -300))
	elif weapon.title.to_lower().contains("missile"):
		weapon.start(position + Vector2(0, -64))
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
		
	# tie to autobombing
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
		var bomb = bomb_scene.instantiate()
		
		# debugger compalins about not using call_deferred,
		# but that breaks for me
		get_tree().root.add_child(bomb)
		
		bomb.execute(position)
		emit_signal("bomb_used")
		bomb_timer.wait_time = bomb_config.recharge_time
		bomb_timer.start()
		emit_signal("bomb_charging", bomb_config.recharge_time)
	else:
		print("waiting on bomb timer to recharge")
		
func _on_gun_cooldown_timeout():
	can_shoot = true
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.explode()
		take_damage(1)
		
func _on_main_player_lives(num_lives):
	remove_bullets()
	lives = num_lives
	reset()

func _on_invulnerability_timer_timeout():
	$AnimationPlayer.stop()
	invulnerable = false

func _on_main_end_stage(_current, _results):
	remove_bullets()
	hide()

func _on_bomb_timer_timeout():
	emit_signal("bomb_recharged")

func _on_special_weapon_timer_timeout():
	special_available = true
