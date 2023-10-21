extends AudioStreamPlayer2D

signal new_song

@onready var bg_music_volume : int = -15

var playlist : Array[AudioStreamMP3] = []
var song0 = preload("res://sound/music/Blue_Space.mp3")
var song1 = preload("res://sound/music/Echoes_of_Orion.mp3")
var song2 = preload("res://sound/music/Retro_Driver.mp3")
var song3 = preload("res://sound/music/Retro_Samurai.mp3")
var song4 = preload("res://sound/music/Soul_Star.mp3")
var song5 = preload("res://sound/music/StarStrux.mp3")
var song6 = preload("res://sound/music/Wave_After_Wave.mp3")

var bg_music = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	playlist.append(song0)
	playlist.append(song1)
	playlist.append(song2)
	playlist.append(song3)
	playlist.append(song4)
	playlist.append(song5)
	playlist.append(song6)
	var song = playlist[randi() % playlist.size()]
	
	bg_music.stream = load(song.resource_path)
	bg_music.autoplay = true
	bg_music.volume_db = bg_music_volume
	add_child(bg_music)
	print("%s %f" % [song.resource_path , bg_music.volume_db])
	emit_signal("new_song", song.resource_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_finished():
	var song = randi() % playlist.size()
	bg_music.stream = load(song.resource_path)
	bg_music.autoplay = true
	bg_music.volume_db = -20
	add_child(bg_music)
