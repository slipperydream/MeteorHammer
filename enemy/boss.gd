extends "res://enemy/shooting_enemy.gd"
signal boss_leaving

var entered_screen : bool = false
var centered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	entered_screen = true
	$MovementTimer.start()
	$ShootTimer.stop()

func _on_movement_timer_timeout():
	speed = 0
	if centered == false:
		centered = true
		$ShootTimer.wait_time = randf_range(shoot_interval_min, shoot_interval_max)
		$ShootTimer.start()
		$MilkingTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()
	
func _on_milking_timer_timeout():
	emit_signal("boss_leaving")
	speed = -50
