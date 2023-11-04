extends Node2D


class_name HealthComponent

signal died
signal death_source
signal hit

@export var lives : int = 1
@export var max_health : int = 1
@export var health : int = 1

@onready var parent = get_parent()

var invulnerable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	
func take_damage(damage, source=null):
	emit_signal("hit")
	
	if invulnerable: 
		return
	
	if parent is Player: # and autobombing:
		var success = parent.use_bomb()
		if success:
			return
	
	health -= damage
	
	if health <= 0:
		died.emit()
		emit_signal("death_source", source)

func set_invulnerability(value):
	invulnerable = value
