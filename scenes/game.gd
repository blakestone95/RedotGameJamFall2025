class_name Game extends Node2D
# NOTE: Game is assigned the group "game" for ease of access across scenes

enum GameState {EXPLORE, REBUILD}

## Scene that shows when we are in the Explore state
const explore_scene = "res://scenes/overworld/Overworld.tscn"
## Scene that shows when we are in the Rebuild state
const rebuild_scene = "res://scenes/colony/Colony.tscn"
@onready var open_scene: Node2D = $OpenScene

var colony_inventory: Inventory
## Provide the ItemData resources in the order you want them to appear
@export var inventory_items: Array[ItemData] 

var colony_upgrades: Dictionary = {
	Colony.Rooms.RANCH: false,
	Colony.Rooms.FARM: false,
	Colony.Rooms.GUARD: false,
	Colony.Rooms.HOUSES: false,
	Colony.Rooms.ROYAL_CHAMBERS: false,
	Colony.Rooms.SCOUT: false,
	Colony.Rooms.STORAGE: false,
}
# Literally only so the Royal Chamber room can monitor when colony_upgrades changes
signal room_rebuilt

# Start in the colony screen on game start
var state: GameState = GameState.REBUILD
var day: int = 0

@onready var music: AudioStreamPlayer = $Music
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
	open_scene.add_child(scene)
	music.stream = MenuMusic
	music.play()
	
	# Connect to signals
	SignalManager.update_game_state.connect(on_state_update)

func on_state_update(new_state: GameState) -> void:
	assert(new_state is GameState, "Signal update_game_state must be emitted with an argument of type GameState")
	if state == new_state: return
	state = new_state

	# When the state updates, remove the current scene and load the apropriate scene
	# Also update what music is playing
	for child in open_scene.get_children(): child.queue_free()
	var scene: Node2D
	if state == GameState.EXPLORE:
		day += 1
		scene = preload(explore_scene).instantiate()
		music.stream = GameMusic
	if state == GameState.REBUILD:
		scene = preload(rebuild_scene).instantiate()
		music.stream = MenuMusic
	
	assert(scene != null, "Tried to transition to game state %s with no scene attached" % new_state)
	open_scene.add_child(scene)
	music.play()

func rebuild_room(type: Colony.Rooms):
	assert(colony_upgrades.has(type), "colony_upgrade dictionary has no key for type " + str(type))
	colony_upgrades[type] = true
	room_rebuilt.emit()
