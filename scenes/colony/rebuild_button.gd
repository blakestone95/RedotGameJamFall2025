class_name RebuildButton extends Button

@export var room_type: Colony.Rooms
@export var costs: Dictionary = {
	ItemData.Type.LEAF: 0,
	ItemData.Type.STICK: 0,
	ItemData.Type.PEBBLE: 0,
	ItemData.Type.FOOD: 0,
}
@export var destroyed_room: Sprite2D
@export var rebuilt_room: Sprite2D

var game: Game

func _enter_tree() -> void:
	# Get the game node so we can access the inventory
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
	
	update_state()
	game.colony_inventory.updated.connect(update_state)

# Handle all state updates
func update_state() -> void:
	var rebuilt = check_rebuilt_state()
	if rebuilt: return # Can exit processing early if the room is rebuilt already
	check_can_afford_rebuild()
	show_costs()

func check_rebuilt_state() -> bool:
	if game.colony_upgrades[room_type]:
		rebuilt_room.show()
		destroyed_room.hide()
		return true
	
	rebuilt_room.hide()
	destroyed_room.show()
	return false

# Check if we have the right resources, disable if we don't
func check_can_afford_rebuild() -> void:
	disabled = false
	for type in costs.keys():
		var cost = costs[type]
		if cost < 1: continue
		if game.colony_inventory.items[type] < cost:
			disabled = true
			break

# TODO: Display costs as icons with counts
func show_costs() -> void:
	var costs_str = "Rebuilding this room costs "
	var first = true
	for type in costs.keys():
		var cost = costs[type]
		var type_name = ItemData.type_name_singular[type] if cost == 1 else ItemData.type_name_plural[type]
		if !first: costs_str += ", " 
		else: first = false
		costs_str += str(cost) + " " + type_name
	tooltip_text = costs_str
	pass

func on_rebuild() -> void:
	# Button will be disabled if we can't afford, so don't need to check
	game.rebuild_room(room_type)
	update_state()
