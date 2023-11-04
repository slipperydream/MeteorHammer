extends Area2D

@export var title : String = "mine"
@export var speed : int = 10
var direction : Vector2 = Vector2(0, 1)
@export var blast_radius : int = 128
@export var power : int = 5
@export var firing_sound : AudioStreamWAV
@export var explosion_sound : AudioStreamWAV
@onready var damage_type =  DamageConstants.DamageTypes.SPECIAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction

func start(pos, dir):
	AudioStreamManager.play(firing_sound.resource_path, true)
	position = pos
	direction = dir
	$SelfDestructTimer.start()
	$AnimationPlayer.play("moving")
	
func _on_area_entered(area):
	if area is HitboxComponent:
		await get_tree().create_timer(1).timeout
		damage_targets()
		explode()

func damage_targets():
	var potential_targets = get_tree().get_nodes_in_group("enemy")
	for tgt in potential_targets:
		var tgt_pos = tgt.position
		var dis = tgt_pos.distance_to(position) 
		if dis < blast_radius:
			tgt.take_damage(power, damage_type)
				
# Possibly convert this to freeing shortly before leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_self_destruct_timer_timeout():
	damage_targets()
	explode()
	
