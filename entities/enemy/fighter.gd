extends Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func start(pos):
	super.start(pos)	
	$HaltTimer.start()
		
func _on_halt_timer_timeout():
	speed = 0
	$ShootingComponent.shoot()
	$ReverseTimer.start()

func _on_reverse_timer_timeout():
	speed = -85
	set_rotation_degrees(180)
	direction = Vector2(0,1)
