class_name RebuildButton extends Button

@export var room_type: Colony.Rooms
@export var costs: Dictionary = {
	ItemData.Type.LEAF: 0,
	ItemData.Type.STICK: 0,
	ItemData.Type.PEBBLE: 0,
	ItemData.Type.FOOD: 0,
}
@export var rubble_pile: RubblePile
@export var destroyed_room: Sprite2D
@export var rebuilt_room: Sprite2D

var game: Game

func _enter_tree() -> void:
	# Get the game node so we can access the inventory
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
	
	# Since Royal Chamber state is dependent on all the other rooms being rebuilt, 
	# we have to check if it can be rebuilt every time any other room is rebuilt
	if room_type == Colony.Rooms.ROYAL_CHAMBERS:
		game.room_rebuilt.connect(check_can_afford_rebuild)
	
	update_state(false)
	game.colony_inventory.updated.connect(update_state)

# Handle all state updates
func update_state(rocks_falling: bool) -> void:
	var rebuilt = check_rebuilt_state(rocks_falling)
	if rebuilt: return # Can exit processing early if the room is rebuilt already
	check_can_afford_rebuild()
	show_costs()

# Checks against the upgrade state from Game to decide what should be shown
func check_rebuilt_state(rocks_falling: bool) -> bool:
	if game.colony_upgrades[room_type]:
		hide()
		rebuilt_room.show()
		destroyed_room.hide()
		# We only want to hide the rubble pile when we aren't playing the falling animation, e.g. on initial load
		if !rocks_falling: rubble_pile.hide()
		return true
	
	show()
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
			
	# The Royal Chamber rcan only be rebuilt when everything else has
	if room_type == Colony.Rooms.ROYAL_CHAMBERS:
		for type in game.colony_upgrades.keys():
			if type == room_type: continue
			if game.colony_upgrades[type] == false:
				disabled = true
				break

# TODO: Display costs as icons with counts
func show_costs() -> void:
	if room_type == Colony.Rooms.ROYAL_CHAMBERS and disabled:
		tooltip_text = "All other rooms must be rebuit before\nRoyal Chamber can be rebuilt"
		return
	
	var costs_str = "Rebuilding this room costs:\n"
	var first = true
	for type in costs.keys():
		var cost = costs[type]
		var type_name = ItemData.type_name_singular[type] if cost == 1 else ItemData.type_name_plural[type]
		if !first: costs_str += ", " 
		else: first = false
		costs_str += str(cost) + " " + type_name
	tooltip_text = costs_str

func on_rebuild() -> void:
	# Button will be disabled if we can't afford to rebuild, so don't need to check that here
	game.rebuild_room(room_type, costs)
	hide()
	if rubble_pile != null:
		rubble_pile.rubble_fall()
	update_state(true)
	
	if room_type == Colony.Rooms.ROYAL_CHAMBERS:
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://menus/WinMenu.tscn")
