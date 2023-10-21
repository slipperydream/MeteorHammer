extends Area2D

@export var title : String = 'enemy weapon'
@export var speed : int = 75
@export var direction : Vector2 = Vector2(0, 1)
@export var power : int = 1
@export var firing_sound : AudioStreamWAV
@export var animate : bool = true

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

func start(pos, dir):
	AudioStreamManager.play(firing_sound.resource_path, true)
	position = pos
	direction = dir
