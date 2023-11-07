extends Enemy
var turn : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if turn:
		velocity = transform.y * -0.5  * speed
		rotation += -0.5 * 1.5 * delta
	super._process(delta)
	
	
func start(pos):
	super.start(pos)

func _on_turn_timer_timeout():
	turn = !turn
	$TurnTimer.wait_time = 2
	$TurnTimer.start()
	
