extends Node2D


class_name HealthComponent

signal killed
signal hit
signal use_bomb

@export var max_health : int = 1
@export var health : int = 1

@onready var parent = get_parent()
@onready var autobomb = SettingsManager.get_autobomb()
var invulnerable : bool = false
var is_dead : bool = false
var bomb_available : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	
func take_damage(damage, source):
	emit_signal("hit")
	
	if is_dead:
		return
		
	if invulnerable: 
		return
	
	if autobomb and bomb_available:
		emit_signal("use_bomb")
		return
	
	health -= damage
	
	if health <= 0:
		killed.emit(source)
		is_dead = true

func set_invulnerability(value):
	invulnerable = value
