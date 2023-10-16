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
@export var bullet_scene : PackedScene
var can_shoot : bool = true

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
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position + Vector2(0, -8))
	
func start():
	lives = max_lives
	reset()
	$GunCooldown.wait_time = cooldown
	
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
	

func _on_main_stage_cleared():
	set_shield(max_shield)
