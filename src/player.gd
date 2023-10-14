extends Area2D

@export var speed : int = 150
@export var cooldown : float = 0.25
@export var bullet_scene : PackedScene
var can_shoot : bool = true

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var shipsize : int = $Ship.texture.get_height()
# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	
func start():
	position = Vector2(screensize.x / 2, screensize.y - (shipsize * 4))
	$GunCooldown.wait_time = cooldown

func shoot():
	if can_shoot == false:
		return
	can_shoot = false
	$GunCooldown.start()
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position + Vector2(0, -8))

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
		
func _on_gun_cooldown_timeout():
	can_shoot = true
