extends Enemy

class_name Mine
@export var arming_distance : int = 250
@export var countdown : int = 5
var armed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if not armed:
		if can_I_arm():
			$AnimationPlayer.play("arm")
			if homing:
				speed = 50

func _on_area_entered(area):
	if area.name == "Player":
		area.take_damage(1)
		explode()
		remove()

func can_I_arm():
	var dis = player.position.distance_to(position)
	if dis < arming_distance:
		arm_trigger()
		return true

func arm_trigger():
	armed = true
	$SelfDestructTimer.wait_time = countdown
	$SelfDestructTimer.start()

func _on_self_destruct_timer_timeout():
	explode()
	remove()
