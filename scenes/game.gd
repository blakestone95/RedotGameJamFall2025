class_name Game extends Node2D
# NOTE: Game is assigned the group "game" for ease of access across scenes

enum GameState {EXPLORE, REBUILD}

# Start in the colony screen on game start
var state: GameState = GameState.REBUILD
const win_scene = "res://menus/WinMenu.tscn"
const lose_scene = "res://menus/LoseMenu.tscn"
var day: int = 0
@export var food_base_req: int = 16
@export var food_increase_per_room: int = 1
@export var food_decrease_farm: int = 6
@export var food_decrease_ranch: int = 9
@export var food_increase_house: int = 10

## Scene that shows when we are in the Explore state
const explore_scene = "res://scenes/overworld/Overworld.tscn"
## Scene that shows when we are in the Rebuild state
const rebuild_scene = "res://scenes/colony/Colony.tscn"
## Stores the currently open scene (depending on game state)
@onready var open_scene: Node2D = $OpenScene

@onready var exploration_timer: Timer = $ExplorationTimer

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
# So scripts can monitor when colony_upgrades changes
signal room_rebuilt

@onready var music: AudioStreamPlayer = $Music
var ColonyMusic = preload("res://data/audio_assets/music/NightLullaby.mp3")
var ExplorationMusic = preload("res://data/audio_assets/music/DayMusic.mp3")

func _ready() -> void:
	# Set up inventory
	var intentory_data: Dictionary = {}
	for item in inventory_items:
		var item_data = item.duplicate() as ItemData
		item_data.max_amount = -1 # Colony has unlimited inventory
		intentory_data[item.type] = item_data
	colony_inventory = Inventory.new(intentory_data)
	
	#For Debugging
	#for i in range(4):
	#	colony_inventory.increase_item(i,100)
	
	# Render initial state
	var scene = preload(rebuild_scene).instantiate()
	open_scene.add_child(scene)
	music.stream = ColonyMusic
	music.play()
	
	# Connect to signals
	SignalManager.update_game_state.connect(on_state_update)
	exploration_timer.timeout.connect(on_timer_expired)

func on_lose_game() -> void:
	get_tree().change_scene_to_file(lose_scene)

func on_win_game() -> void:
	get_tree().change_scene_to_file(win_scene)

func on_state_update(new_state: GameState) -> void:
	assert(new_state is GameState, "Signal update_game_state must be emitted with an argument of type GameState")
	if state == new_state: return
	state = new_state
	if state == GameState.REBUILD:
		var Fade = load("res://scenes/Fade.tscn").instantiate()
		add_child(Fade)
		Fade.get_node("ColorRect").get_node("AnimationPlayer").play("FadeEffect")
		await get_tree().create_timer(5.0).timeout
		Fade.queue_free()

	# When the state updates, remove the current scene and load the apropriate scene
	# Also update what music is playing
	for child in open_scene.get_children(): child.queue_free()
	var scene: Node2D
	if state == GameState.EXPLORE:
		day += 1
		scene = preload(explore_scene).instantiate()
		exploration_timer.start()
		music.stream = ExplorationMusic
	if state == GameState.REBUILD:
		consume_food()
		scene = preload(rebuild_scene).instantiate()
		exploration_timer.stop()
		music.stream = ColonyMusic
	
	assert(scene != null, "Tried to transition to game state %s with no scene attached" % new_state)
	open_scene.add_child(scene)
	music.play()

func consume_food() -> void:
	# Could potentially make unlocking rooms increase maintenance costs
	var food_consumed = get_req_food()
	print(colony_inventory)
	var remainder = colony_inventory.decrease_item(ItemData.Type.FOOD, food_consumed)
	print(remainder)
	if remainder > 0:
		# We didn't have enough food... game over
		on_lose_game()

func get_req_food() -> int:
	var req_food: int = food_base_req
	if colony_upgrades[Colony.Rooms.RANCH]: req_food -= food_decrease_ranch
	if colony_upgrades[Colony.Rooms.FARM]: req_food -= food_decrease_farm
	if colony_upgrades[Colony.Rooms.HOUSES]: req_food += food_increase_house
	if colony_upgrades[Colony.Rooms.SCOUT]: req_food += food_increase_per_room
	if colony_upgrades[Colony.Rooms.GUARD]: req_food += food_increase_per_room
	if colony_upgrades[Colony.Rooms.STORAGE]: req_food += food_increase_per_room
	return req_food

func on_timer_expired() -> void:
	# Could potentially show a message here if we have time
	on_state_update(Game.GameState.REBUILD)

func rebuild_room(type: Colony.Rooms, costs: Dictionary, disable_costs: bool) -> void:
	assert(colony_upgrades.has(type), "colony_upgrade dictionary has no key for type " + str(type))

	if !disable_costs:
		# Checking costs is handled in RebuildButton, we don't need to recheck here
		for item_type in costs.keys():
			var cost = costs[item_type]
			colony_inventory.decrease_item(item_type, cost)

	colony_upgrades[type] = true
	room_rebuilt.emit()
