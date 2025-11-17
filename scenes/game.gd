class_name Game extends Node2D

enum GameState {EXPLORE, REBUILD}

## Scene that shows when we are in the Explore state
const explore_scene = "res://scenes/Overworld.tscn"
## Scene that shows when we are in the Rebuild state
const rebuild_scene = "res://scenes/Colony.tscn"

var colony_inventory: Inventory
## Provide the ItemData resources in the order you want them to appear
@export var inventory_items: Array[ItemData]

# Start in the colony screen on game start
var state: GameState = GameState.REBUILD

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
	
	# Render initial state
	var scene = preload(rebuild_scene).instantiate()
	add_child(scene)
	
	# Connect to signals
	SignalManager.update_game_state.connect(on_state_update)
	
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

func on_state_update(new_state: GameState) -> void:
	assert(new_state is GameState, "Signal update_game_state must be emitted with an argument of type GameState")
	if state == new_state: return
	
	# When the state updates, remove the current scene and load the aapropriate scene
	for child in get_children(): child.queue_free()
	var scene: Node2D
	if new_state == GameState.EXPLORE:
		scene = preload(explore_scene).instantiate()
	if new_state == GameState.REBUILD:
		scene = preload(rebuild_scene).instantiate()
	assert(scene != null, "Tried to transition to game state %s with no scene attached" % new_state)
	add_child(scene)
