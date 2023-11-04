extends Resource

class_name Attack

@export var attack_name : String = 'Attack'
@export var Firing_Sequence : Array[Bullet] = []
@export_range(1,20) var salvos : int = 1
@export_range(0.25,5.0) var salvo_delay : float = 0.3

