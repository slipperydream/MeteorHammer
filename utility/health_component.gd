extends Node2D


class_name HealthComponent

signal killed
signal hit

@export var max_health : int = 1
@export var health : int = 1

@onready var parent = get_parent()

var invulnerable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	
func take_damage(damage, source):
	emit_signal("hit")
	
	if invulnerable: 
		return
	
	if parent is Player: # and autobombing:
		var success = parent.use_bomb()
		if success:
			return
	
	health -= damage
	
	if health <= 0:
		killed.emit(source)

func set_invulnerability(value):
	invulnerable = value
