extends Node2D

func _on_halt_timer_timeout():
	speed = 0
	$ShootingComponent.shoot()
	$ReverseTimer.start()

func _on_reverse_timer_timeout():
	speed = -85
	set_rotation_degrees(180)
	direction = Vector2(0,1)
