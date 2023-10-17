extends Area2D

signal died
signal out_of_lives
signal shield_changed
signal gained_life

@export var max_shield = 10
var shield = max_shield

@export var max_lives = 3
var lives = max_lives

@export var speed : int = 150
@export var cooldown : float = 0.25
@export var item_recharge_time : float = 5.0
@export var weapon_scene : PackedScene
@export var item_scene : PackedScene
var can_shoot : bool = true
var num_shots : int = 1

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : int = $Ship.texture.get_height()

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
	if $ItemCharge.is_stopped() and Input.is_action_just_pressed("use_item"):
		use_item()

func reset():
	if not visible:
		show()
	position = Vector2(screensize.x / 2, screensize.y - (shipsize * 4))
	can_shoot = true
	#set_shield(max_shield)
	shield = max_shield
			
func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)	
	
	# check health
	if shield <= 0:
		lives = max(0, lives - 1)
		hide()
		if lives > 0:
			died.emit()
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
		var angle = deg_to_rad(80 + i * 20)
		weapon.start(position + Vector2(0, -8), Vector2.RIGHT.rotated(angle))
	
func start():
	lives = max_lives
	reset()
	$GunCooldown.wait_time = cooldown
	$ItemCharge.wait_time = item_recharge_time
	$ItemCharge.start()
	
func take_damage(value):
	var new_value = max(0, shield - value)
	set_shield(new_value)

func _on_gun_cooldown_timeout():
	can_shoot = true
	
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		set_shield(shield - (max_shield / 2))

func _on_main_new_game():
	start()
	
func _on_main_start_game(start_lives):
	max_lives = start_lives
	start()
	
func _on_main_stage_cleared(stage):
	set_shield(max_shield)
	upgrade_weapon(stage)
	$ItemCharge.stop()

func upgrade_weapon(stage):
	match stage:
		2:
			num_shots = 2
		3: 
			num_shots = 1
			weapon_scene = load("res://scenes/weapons/bullet_level2.tscn")
		4:
			num_shots = 2
	
func use_item():	
	#var item = item_scene.instantiate()
	#get_tree().root.add_child(item)
	#item.execute()
	$ItemCharge.wait_time = item_recharge_time
	$ItemCharge.start()
	print("using item")

func _on_item_charge_timeout():
	print("item charged")
	#use_item()
