extends Area2D

signal died

@export var title : String = "Enemy"
@export var is_boss : bool = false
@export var points : int = 100
@export var speed : int = 30
@export var hp : int = 5
@export var is_GOB : bool = false
@export var explosion_sound : AudioStreamWAV
var is_alive : bool = true

@onready var screensize : Vector2 = get_viewport_rect().size
@onready var enemy_size : Vector2 = $Sprite2D.get_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_GOB:
		z_index = 0
	else:
		z_index = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + enemy_size.y:
		remove()
	
func start(pos):
	position = Vector2(pos.x, pos.y)

func take_damage(value):
	if is_alive == false:
		return
	hp = max(0, hp - value)
	if hp == 0:
		is_alive = false
		die()
	else:
		$AnimationPlayer.play("hit")
			
		
func die():
	speed = 0
	set_deferred("monitoring", false)
	emit_signal("died", points)
	explode()
	remove()

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	
func remove():
	queue_free()	

func _on_player_died():
	pass
