extends "res://enemy/shooting_enemy.gd"

const FACING = {
	Vector2(0, -1): 'north',
	Vector2(1, -1): 'northeast',
	Vector2(1, 0): 'east',
	Vector2(1, 1): 'southeast',
	Vector2(0, 1): 'south',
	Vector2(-1, 1): 'southwest',
	Vector2(-1, 0): 'west',
	Vector2(-1, -1): 'northwest',
}

@onready var player = get_tree().get_first_node_in_group("player")
var vec_to_player : Vector2 = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_scene.append(preload("res://enemy/weapons/spinning_bullet.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	var anim_direction = get_facing_direction(vec_to_player)
	$AnimationPlayer.play(anim_direction)
	
func shoot():
	var bullet = bullet_scene[0].instantiate()
	var angle = vec_to_player.angle()
	fire_bullet(bullet, position, angle)

func get_facing_vector(vtp):
	var min_angle = 360
	var facing = Vector2()
	for vec in FACING.keys():
		var ang = abs(vtp.angle_to(vec))
		if ang < min_angle:
			min_angle = ang
			facing = vec
	return facing

func get_facing_direction(vtp):
	var facing_vec = get_facing_vector(vtp)
	return FACING[facing_vec]
