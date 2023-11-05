extends Node

class SoundEffect:
	var path: String
	var randomize_pitch : bool

	
var num_players = 12
var bus = "SFX"

var available_players = []
var sound_queue = []

var play_sounds : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		p.volume_db = SettingsManager.get_audio_bus_volume(bus)
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available_players.append(stream)

func play(sound_path, randomize_pitch : bool = false):
	if play_sounds:
		var sound = SoundEffect.new()
		sound.path = sound_path
		sound.randomize_pitch = randomize_pitch
		sound_queue.append(sound)
#	else:
#		print("sorry not playing sounds")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func clear_queue():
	sound_queue.clear()

func start():
	play_sounds = true
	
func stop():
	play_sounds = false
	for i in available_players:
		i.stop()
