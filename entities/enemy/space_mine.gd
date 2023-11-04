extends Enemy

class_name Enemy_Mine
@export var blast_radius : int = 128
@export var countdown : int = 5
@export var steer_force = 50.0
@export var homing : bool = false

var armed : bool = false

@onready var damage_type = DamageConstants.DamageTypes.BOMB

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if armed and homing:
		position = position + speed * delta * direction + steer_towards_player(delta)
	else:
		position = position + speed * delta * direction

func arm_trigger():
	armed = true
	$AnimationPlayer.play("arm")
	$SelfDestructTimer.wait_time = countdown
	$SelfDestructTimer.start()


func steer_towards_player(delta):
	var steer = Vector2.ZERO
	if player:
		var desired = vec_to_player * speed
		steer = (desired - direction).normalized() * steer_force * delta
	return steer
	
func _on_self_destruct_timer_timeout():
	damage_area()
	explode()
	remove()


func _on_hitbox_component_area_entered(area):
	damage_area()
	explode()
	remove()
	
func damage_area():
	var potential_targets = get_tree().get_nodes_in_group("player")
	for tgt in potential_targets:
		var tgt_pos = tgt.position
		var dis = tgt_pos.distance_to(position) 
		if dis < blast_radius:
			if tgt.has_method("take_damage"):
				tgt.take_damage(1, damage_type)

func _on_trigger_area_entered(area):
	arm_trigger()
	if homing:
		speed = 55
