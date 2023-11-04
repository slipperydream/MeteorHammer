extends Area2D

class_name HitboxComponent

@export var health_component : HealthComponent

func take_damage(power, source=null):
	if health_component:
		health_component.take_damage(power, source)

