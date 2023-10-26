extends Control

@export var backgrounds : Array[Texture2D] = []
@onready var background = $PanelContainer/Sprite2D
@onready var screensize : Vector2 = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	background.texture = backgrounds[randi() % backgrounds.size()]
	background.size.x = screensize.x
	background.size.y = screensize.y
	background.modulate = Color.AQUAMARINE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
