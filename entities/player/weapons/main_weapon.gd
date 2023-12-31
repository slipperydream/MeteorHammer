extends Node2D

@export var title = "weapon"
@export var speed = -250
@export var direction : Vector2 = Vector2(0, 1)
@export var power : int = 1
@export var firing_sound : AudioStreamWAV
@onready var damage_type =  DamageConstants.DamageTypes.BULLET


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction
	look_at(position)

func start(pos, dir, angle):
	$Sprite2D.modulate = SettingsManager.get_bullet_color()
	AudioStreamManager.play(firing_sound.resource_path, true)
	position = pos
	direction = dir
	rotation_degrees = angle - 90

# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		area.take_damage(power, damage_type)
		queue_free()
