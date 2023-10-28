extends AudioStreamPlayer2D

signal new_song

@onready var bg_music_volume : int = -25
@export var title_song = preload("res://sound/music/stg_noloop003.ogg")
@export var stage_1_theme = preload("res://sound/music/stg_st001.ogg")
@export var stage_2_theme = preload("res://sound/music/stg_st002.ogg")
@export var stage_3_theme = preload("res://sound/music/stg_st003.ogg")
@export var stage_4_theme = preload("res://sound/music/stg_st004.ogg")
@export var stage_5_theme = preload("res://sound/music/stg_st005.ogg")
@export var stage_6_theme = preload("res://sound/music/stg_st006.ogg")
@export var boss_theme_1 = preload("res://sound/music/stg_bs001.ogg")
@export var boss_theme_2 = preload("res://sound/music/stg_bs002.ogg")
@export var boss_theme_3 = preload("res://sound/music/stg_bs003.ogg")
@export var boss_theme_4 = preload("res://sound/music/stg_bs004.ogg")
@export var boss_theme_5 = preload("res://sound/music/stg_bs005.ogg")
@export var boss_theme_6 = preload("res://sound/music/stg_bs006.ogg")
@export var boss_theme_TLB = preload("res://sound/music/stg_bs001.ogg")

@export var song_dir : String = "res://sound/music/"
@export var randomize_music : bool = false

var current_song : AudioStreamOggVorbis
var playlist : Array[AudioStreamOggVorbis] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_songs(song_dir)

func play_title_song():
	current_song = title_song
	play_song(title_song)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_songs(path):
	var dir = DirAccess.open(path)
	if dir.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == 'ogg':
				var song_title = path+file_name
				var song = load(song_title)
				playlist.append(song)
			file_name = dir.get_next()
		dir.list_dir_end()
		
func _on_finished():
	if randomize_music:
		play_song(current_song)
	else:
		play_song(current_song)

func fade_in():
	var child = get_child(0)
	var tween = create_tween()
	tween.tween_property(child, "volume_db", -25, 2)

func fade_out():
	var child= get_child(0)
	var tween = create_tween()
	tween.tween_property(child, "volume_db", -80, 2)
	
func get_random_song():
	var song = playlist[randi() % playlist.size()]
	return song
	
func play_song(song):
	current_song = song
	for child in get_children():
		remove_child(child)
	var bg_music = AudioStreamPlayer.new()
	bg_music.stream = load(song.resource_path)
	bg_music.autoplay = true
	bg_music.volume_db = bg_music_volume
	add_child(bg_music)
	emit_signal("new_song", song.resource_name)
	
func play_stage_theme(value):
	match value:
		1:
			play_song(stage_1_theme)
		2:
			play_song(stage_2_theme)
		3:
			play_song(stage_3_theme)
		4:
			play_song(stage_4_theme)
		5:
			play_song(stage_5_theme)
		6:
			play_song(stage_6_theme)

func play_boss_theme(value):
	match value:
		1:
			play_song(boss_theme_1)
		2:
			play_song(boss_theme_2)
		3:
			play_song(boss_theme_3)
		4:
			play_song(boss_theme_4)
		5:
			play_song(boss_theme_5)
		6:
			play_song(boss_theme_6)
		7:
			play_song(boss_theme_1)
