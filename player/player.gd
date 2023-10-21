extends Area2D

signal died
signal out_of_lives
signal shield_changed
signal gained_life
signal item_charging
signal item_recharged
signal item_used
signal weapon_changed
signal item_changed

@export var max_shield : int = 1
var shield = max_shield

@export var max_lives = 3
var lives = max_lives

@export var sensitivity : float = 2.0
@export var speed : int = 150
@export var cooldown : float = 0.25
@export var item_recharge_time : float = 5.0
@export var weapon_scene : PackedScene
@export var item_scene : PackedScene
var can_shoot : bool = true
var num_shots : int = 1

@export var explosion_sound : AudioStreamWAV
@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : int = $Ship.texture.get_height()

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	sensitivity = max(0.5, sensitivity)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input /= sensitivity
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,8))
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
func _input(event):	
	if event.is_action_pressed("use_item"):
		use_item()
		
func reset():
	if not visible:
		show()
	position = Vector2(screensize.x / 2, screensize.y - (shipsize * 4))
	can_shoot = true
	shield = max_shield
			
func set_shield(value):
	shield = min(max_shield, value)
	emit_signal("shield_changed",max_shield, shield)	
		
	# check health
	if shield <= 0:
		lives = max(0, lives - 1)
		hide()
		if lives > 0:
			died.emit()
			AudioStreamManager.play(explosion_sound.resource_path)
			reset()			
		else:
			out_of_lives.emit()
		
func shoot():
	if can_shoot == false:
		return
	can_shoot = false
	$GunCooldown.start()	
	for i in range(num_shots):
		var weapon = weapon_scene.instantiate()
		get_tree().root.add_child(weapon)
		var angle = deg_to_rad(90)
		if num_shots % 3 == 0:
			angle = deg_to_rad(70 + i * 20)		
		weapon.start(position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))	
		
func new_game():
	lives = max_lives
	$GunCooldown.wait_time = cooldown
	emit_signal("weapon_changed", "beam")
	reset()
	
func take_damage(value):
	var new_value = max(0, shield - value)
	set_shield(new_value)

func upgrade_weapon(stage):
	match stage:
		1:
			num_shots = 3
		2: 
			num_shots = 1
			weapon_scene = load("res://player/weapons/bullet_level2.tscn")
			emit_signal("weapon_changed", "charged_beam")
		3:
			num_shots = 3
	
func use_item():	
	if $ItemCharge.is_stopped():
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

func _on_main_new_game():
	new_game()
		
func _on_main_start_game(start_lives, _stage):
	new_game()
	max_lives = start_lives
	$ItemCharge.wait_time = item_recharge_time
	$ItemCharge.start()
	emit_signal("item_charging")
		
func _on_main_stage_cleared(stage):
	set_shield(max_shield)
	upgrade_weapon(stage)

func _on_item_charge_timeout():
	emit_signal("item_recharged")
