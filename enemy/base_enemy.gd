extends Area2D

signal died

@export var title : String = "Enemy"
@export var is_boss : bool = false
@export var points : int = 100
@export var speed : int = 30
@export var hp : int = 1

@export var explosion_sound : AudioStreamWAV


@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + enemy_size.y:
		remove()
	
func start(pos):
	position = Vector2(pos.x, pos.y)

func take_damage(value):
	hp = max(0, hp - value)
	if hp == 0:
		explode()
	else:
		$AnimationPlayer.play("hit")
		
func explode():
	speed = 0
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.play("explode")
	emit_signal("died", points)
	await $AnimationPlayer.animation_finished
	remove()

func remove():
	set_deferred("monitoring", false)
	queue_free()	

func _on_player_died():
	pass
