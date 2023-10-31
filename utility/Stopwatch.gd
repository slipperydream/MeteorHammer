extends Label

@export var display : bool = false
var time_elapsed : float = 0.0
var started : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if display:
		show()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		time_elapsed += delta
		print_time()

func print_time():
	text = format_time(time_elapsed)
	
func format_time(time):
	var minutes : int = time / 60
	var seconds: float = fmod(time, 60)
	var time_string = "%02d:%02f" % [minutes, seconds]
	return time_string

func start():
	started = true

func reset():
	started = false
	time_elapsed = 0

func pause(value : bool = true):
	started = value
	
func stop():
	started = false
	
