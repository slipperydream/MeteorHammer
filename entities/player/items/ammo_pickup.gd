extends Pickup

signal ammo_resupply

@export_range(1,20) var amount : int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func execute():
	super.execute()
	if self.is_connected("ammo_resupply", player._on_ammo_resupply) == false:
		self.connect("ammo_resupply", player._on_ammo_resupply)
	emit_signal("ammo_resupply", amount)
	queue_free()
