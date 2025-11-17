class_name Game extends Node2D

var colony_inventory: Inventory
## Provide the ItemData resources in the order you want them to appear
@export var inventory_items: Array[ItemData]
@onready var music: AudioStreamPlayer = $Music
@onready var overworld: Node2D = $Overworld
var MenuMusic = preload("res://data/audio_assets/music/MenuMusic.mp3")
var GameMusic = preload("res://data/audio_assets/music/NightLullaby.mp3")

func _ready() -> void:
	# Set up inventory
	var intentory_data: Dictionary = {}
	for item in inventory_items:
		intentory_data[item.type] = item.duplicate()
	colony_inventory = Inventory.new(intentory_data)
	music_player()


func _process(delta: float) -> void:
	music_player()


func music_player() -> void:
	if overworld.visible:
		if music.stream != GameMusic:
			music.stream = GameMusic
			music.play()
	elif not overworld.visible:
		if music.stream != MenuMusic:
			music.stream = MenuMusic
			music.play()
	else:
		music.stop()
	if not music.playing:
		music.play()
