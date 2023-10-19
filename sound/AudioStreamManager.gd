extends Node

class SoundEffect:
	var path: String
	var randomize_pitch : bool

@onready var sfx_volume : int = -30
	
var num_players = 8
var bus = "SFX"

var available_players = []
var sound_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		p.volume_db = sfx_volume
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available_players.append(stream)

func play(sound_path, randomize_pitch : bool = false):
	var sound = SoundEffect.new()
	sound.path = sound_path
	sound.randomize_pitch = randomize_pitch
	sound_queue.append(sound)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Play queued sound if any AudioStreamPlayers are available
	if not sound_queue.is_empty() and not available_players.is_empty():
		var sound = sound_queue.pop_front()
		available_players[0].stream = load(sound.path)
		if sound.randomize_pitch:
			available_players[0].pitch_scale = randf_range(0.3, 2.0)
		else:
			available_players[0].pitch_scale = 1.0
		available_players[0].play()
		available_players.pop_front()
