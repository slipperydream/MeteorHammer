extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	rotation = velocity.angle() - deg_to_rad(90)

func start(pos):
	super.start(pos)
	$TurnTimer.start()
	
func _on_turn_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "direction", Vector2(1,0), 2)
	tween.tween_property(self, "direction", Vector2(0,-1), 2)
	tween.tween_property(self, "direction", Vector2(-1,-0), 2)
	tween.tween_property(self, "direction", Vector2(0,1), 2)
