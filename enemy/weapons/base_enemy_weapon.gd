extends Area2D

@export var title : String = 'enemy weapon'
@export var power : int = 1
@export var firing_sound : AudioStreamWAV
@export var animate : bool = true

# Vector2(0, 1) is down 
var direction : Vector2 = Vector2(0, 1)
var speed : int = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_bus_override = true
	audio_bus_name = 'SFX'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction

func _on_area_entered(area):
	if area.name == "Player":
		queue_free()
		area.take_damage(power)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func start(pos, dir, velocity, size = Vector2(0.33,0.33)):
	$Sprite2D.apply_scale(size)
	$CollisionShape2D.apply_scale(size)
	AudioStreamManager.play(firing_sound.resource_path, true)
	position = pos
	direction = dir
	speed = velocity
