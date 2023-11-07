extends Node2D

class_name Player_option

enum Option_Formation { FRONT, SPREAD, LEFT, RIGHT, TAIL }

@export var weapon : PackedScene
@export var x_spacing : int = 24
@export var y_spacing : int = 16
var firing_angle : float = 90
var option_num : int = 0

func shoot():
	var wpn = weapon.instantiate()
	get_tree().root.add_child(wpn)	
	wpn.start(global_position, Vector2.RIGHT.rotated(deg_to_rad(firing_angle)), firing_angle)	

func move(dir):
	match dir:
		"left":
			$Sprite2D.frame = 1
		"right":
			$Sprite2D.frame = 2
		"forward":
			$Sprite2D.frame = 0

func change_formation(formation, player_pos):	
	global_position = get_formation_location(formation, player_pos)
	rotation_degrees = get_option_rotation(formation)
	firing_angle = get_firing_angle(formation)
	
	
func get_formation_location(formation, player_pos):
	match formation:
		Option_Formation.SPREAD:
			if option_num % 2 == 0:
				return Vector2(player_pos.x + x_spacing * option_num, player_pos.y + y_spacing * option_num)
			else:
				return Vector2(player_pos.x - x_spacing * (option_num+1), player_pos.y + y_spacing * option_num)
		Option_Formation.TAIL:
			if option_num % 2 == 0:
				return Vector2(player_pos.x + x_spacing/2 * option_num, player_pos.y + y_spacing * 4)
			else:
				return Vector2(player_pos.x - x_spacing/2 * option_num, player_pos.y + y_spacing * 4)
		Option_Formation.FRONT:
			if option_num % 2 == 0:
				return Vector2(player_pos.x + x_spacing/2 * option_num, player_pos.y - y_spacing * 4)
			else:
				return Vector2(player_pos.x - - x_spacing/2 * option_num, player_pos.y - y_spacing * 4)
		Option_Formation.LEFT:
			return Vector2(player_pos.x - x_spacing * option_num, player_pos.y)
		Option_Formation.RIGHT:
			return Vector2(player_pos.x + x_spacing + x_spacing * option_num, player_pos.y)
					
func get_option_rotation(formation):
	match formation:
		Option_Formation.SPREAD:
			if option_num % 2 == 0:	
				return 15
			else:
				return -15
		Option_Formation.TAIL:
			if option_num % 2 == 0:	
				return 180
			else:
				return -180
		Option_Formation.FRONT, Option_Formation.LEFT, Option_Formation.RIGHT:
			return 0

func get_firing_angle(formation):
	match formation:
		Option_Formation.SPREAD:
			if option_num % 2 == 0:				
				return 105
			else:
				return 75
		Option_Formation.TAIL:
			return 270
		Option_Formation.FRONT, Option_Formation.LEFT, Option_Formation.RIGHT:
			return 90
