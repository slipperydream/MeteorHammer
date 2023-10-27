extends Area2D

signal died
signal out_of_lives
signal gained_life
signal item_charging
signal item_recharged
signal item_used
signal weapon_changed
signal item_changed
signal player_hit

var lives = 3

@export var speed : int = 150
@export var cooldown : float = 0.25
@export var item_recharge_time : float = 5.0
@export var primary_weapon : PackedScene
@export var secondary_weapon : PackedScene
@export var num_shots : int = 3
@export var option_weapons : Array[PackedScene] = []
@export var item_scene : PackedScene
@export var explosion_sound : AudioStreamWAV

var can_shoot : bool = true
var invulnerable : bool = false
var assist_mode_enabled = false
enum Option_Formation { SPREAD, TAIL, SIDES, FRONT}
var option_index = Option_Formation.SPREAD

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : Vector2 = $Ship.texture.get_size()
@onready var left_option = $Ship/LeftOption
@onready var right_option = $Ship/RightOption

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	emit_signal("weapon_changed", "beam")
	position = Vector2(screensize.x / 2, screensize.y - (shipsize.y * 4))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input.x > 0:
		$Ship.frame = 2
		left_option.frame = 2
		right_option.frame = 2
		$Ship/LeftBooster.animation = "right"
		$Ship/RightBooster.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		left_option.frame = 1
		right_option.frame = 1
		$Ship/LeftBooster.animation = "left"
		$Ship/RightBooster.animation = "left"
	else:
		$Ship.frame = 1
		left_option.frame = 0
		right_option.frame = 0
		$Ship/LeftBooster.animation = "forward"
		$Ship/RightBooster.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,8))
	
	if Input.is_action_pressed("primary_weapon_fire"):
		primary_weapon_fire()
	elif Input.is_action_just_pressed("secondary_weapon_fire"):
		secondary_fire()
	
	if assist_mode_enabled:
		if Input.is_action_just_pressed("assist_mode_fire"):
			options_fire()
		
func _input(event):	
	if event.is_action_pressed("use_item"):
		use_item()
	if event.is_action_pressed("switch_formation"):
		switch_option_formation()
		
func make_invulnerable():
	invulnerable = true
	$AnimationPlayer.play("invlunerable")
	$InvulnerabilityTimer.start()	
			
func reset():
	$GunCooldown.wait_time = cooldown
	if not visible:
		show()
	can_shoot = true

func secondary_fire():	
	if can_shoot == false:
		return
	can_shoot = false
	$GunCooldown.start()	
	for i in range(num_shots):
		var weapon = secondary_weapon.instantiate()
		get_tree().root.add_child(weapon)
		var angle = deg_to_rad(90)
		if num_shots % 5 == 0:
			angle = deg_to_rad(70 + i * 10)		
		elif num_shots % 3 == 0:
			angle = deg_to_rad(80 + i * 10)	
		weapon.start(position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))	
	if not assist_mode_enabled:
		options_fire()
		
func primary_weapon_fire():
	if can_shoot == false:
		return
	can_shoot = false
	$GunCooldown.start()	
	for i in range(num_shots):
		var weapon = primary_weapon.instantiate()
		get_tree().root.add_child(weapon)
		var angle = deg_to_rad(90)
		if num_shots % 5 == 0:
			angle = deg_to_rad(70 + i * 10)		
		elif num_shots % 3 == 0:
			angle = deg_to_rad(80 + i * 10)	
		weapon.start($Ship/LeftGun.global_position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))	
		weapon = primary_weapon.instantiate()
		get_tree().root.add_child(weapon)
		weapon.start($Ship/RightGun.global_position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))	
	if not assist_mode_enabled:
		options_fire()

func options_fire():
	var left_option_angle = 75
	var right_option_angle = 105
	
	if option_index == Option_Formation.TAIL:
		left_option_angle = 270
		right_option_angle = 270
	elif option_index == Option_Formation.FRONT:
		left_option_angle = 90
		right_option_angle = 90
	elif option_index == Option_Formation.SIDES:
		left_option_angle = 0
		right_option_angle = 180

	var weapon = option_weapons[option_index].instantiate()
	get_tree().root.add_child(weapon)	
	weapon.start(left_option.global_position, Vector2.RIGHT.rotated(deg_to_rad(left_option_angle)))	
	
	weapon = option_weapons[option_index].instantiate()
	get_tree().root.add_child(weapon)	
	weapon.start(right_option.global_position, Vector2.RIGHT.rotated(deg_to_rad(right_option_angle)))

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
			right_option.global_position.x = global_position.x + shipsize.x/4
			right_option.global_position.y = global_position.y + (shipsize.y/8)
			right_option.set_rotation_degrees(15)
		Option_Formation.TAIL:
			left_option.global_position.x = global_position.x - (shipsize.x/8)
			left_option.global_position.y = global_position.y + shipsize.y
			left_option.set_rotation_degrees(-180)
			right_option.global_position.x = global_position.x + (shipsize.x/8)
			right_option.global_position.y = global_position.y + shipsize.y
			right_option.set_rotation_degrees(180)
		Option_Formation.FRONT:
			left_option.global_position.x = global_position.x - (shipsize.x/5)
			left_option.global_position.y = global_position.y - (shipsize.y/2)
			left_option.set_rotation_degrees(0)
			right_option.global_position.x = global_position.x + (shipsize.x/5)
			right_option.global_position.y = global_position.y - (shipsize.y/2)
			right_option.set_rotation_degrees(0)
		Option_Formation.SIDES:
			left_option.global_position.x = global_position.x - (shipsize.x/3)
			left_option.global_position.y = global_position.y 
			left_option.set_rotation_degrees(-90)
			right_option.global_position.x = global_position.x + (shipsize.x/3)
			right_option.global_position.y = global_position.y
			right_option.set_rotation_degrees(90)
			
func take_damage(_value):
	emit_signal("player_hit")
	
	if invulnerable: 
		return
		
	if $ItemCharge.is_stopped():
		use_item()
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
	
func use_item():	
	if $ItemCharge.is_stopped():
		make_invulnerable()
		var item = item_scene.instantiate()
		get_tree().root.add_child(item)
		item.execute(position)
		emit_signal("item_used")
		$ItemCharge.wait_time = item_recharge_time
		$ItemCharge.start()
		emit_signal("item_charging")
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
	$ItemCharge.wait_time = item_recharge_time
	$ItemCharge.start()
	emit_signal("item_charging")

func _on_item_charge_timeout():
	emit_signal("item_recharged")

func _on_invulnerability_timer_timeout():
	$AnimationPlayer.stop()
	invulnerable = false

func _on_main_end_stage():
	remove_bullets()
	hide()
