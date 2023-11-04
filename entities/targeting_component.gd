extends Node2D

class_name TargetingComponent

signal target_lock

@export var max_distance : int = INF

func acquire_target(pos, group):
	var closet_target = null
	var shortest_distance = max_distance
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_connected("target_lock", enemy._on_player_target_lock) == false:
			target_lock.connect(enemy._on_player_target_lock)
	for target in get_tree().get_nodes_in_group(group):
		if not is_instance_valid(target):
			continue
		if target.targeted:
			continue
		var distance = pos.distance_to(target.position)
		if distance < shortest_distance:
			shortest_distance = distance
			closet_target = target
	if closet_target == null and get_tree().get_nodes_in_group("enemy").size() > 0:
		closet_target = get_tree().get_first_node_in_group("enemy")
	
	if closet_target != null:
		emit_signal("target_lock", closet_target)
	return closet_target	
