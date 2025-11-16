class_name TileMapSpawner extends TileMapLayer

## Point where distance bands reference to determine spawn chance
@export var spawn_anchor: Vector2 = Vector2.ZERO
## Relative spawn chances keyed by the distance in pixels away from the spawn anchor. Recommend the outermost band being set to 1.0. Multiplied with the spawn scalar to determine final spawn chance.
@export var distance_bands: Dictionary = { 0: 0.3, 500: 0.5, 1000: 0.75, 1500: 0.875, 2000: 1.0 }
## Constant spawn chance of cell - 0 meaning nothing can ever spawn and 1.0 meaning every tile spawns something. Multiplied with the distance band to determine final spawn chance.
@export var spawn_scalar: float = 0.05
## Spawn distribution mapping, where the key is the int value assigned to tiles with the [code]item_distribution[/code] custom data layer and the value is the item distribution resource. 0 represents no distribution, so start the mapping with 1.
@export var distribution_mapping: Dictionary = { 1: "res://gameplay/groundItems/spawning/spawn_dist_default.tres" }

# Debug
var spawned_items = []

var spawn_dict: Dictionary = {
	ItemData.Type.LEAF: "res://gameplay/groundItems/resourcePickups/LeafPickup.tscn",
	ItemData.Type.STICK: "res://gameplay/groundItems/resourcePickups/TwigPickup.tscn",
	ItemData.Type.PEBBLE: "res://gameplay/groundItems/resourcePickups/PebblePickup.tscn",
	ItemData.Type.FOOD: "res://gameplay/groundItems/resourcePickups/FoodPickup.tscn",
}

func _ready() -> void:
	# Load distribution mapping resources
	var dist_mapping_loaded: Dictionary
	for key in distribution_mapping.keys():
		var item_url = distribution_mapping[key]
		var loaded_item = load(item_url)
		assert(loaded_item is SpawnDistribution, "Loaded resource at %s is not a SpawnDistribution resource" % item_url)
		dist_mapping_loaded[key] = loaded_item
	
	# Iterate through all tiles
	var cells = get_used_cells()
	for cell in cells:
		# Get the cell data
		var cell_data = get_cell_tile_data(cell)
		var dist_key = cell_data.get_custom_data("item_distribution") as int
		
		# Skip empty distributions
		if dist_key == 0: continue
		
		# Get the distribution list
		assert(dist_mapping_loaded.has(dist_key), "Supplied mapping key %s does not exist in the distribution mapping" % dist_key)
		var distribution = dist_mapping_loaded[dist_key] as SpawnDistribution
		
		# Any tile that can spawn items triggers a roll
		var cell_position = map_to_local(cell)
		var should_spawn = should_spawn_item(cell_position)
		if !should_spawn: continue
		
		# Roll which item to spawn, looping through the distribution dictionary
		# Uses a chance counter so we can loop through linearly without any additional processing
		# Here's an example to show how this works:
		# We roll 0.78. The first item has 40% (0.4) chance, since we're higher than that, its a miss so we move to the second item, adding the chance of the first item to our counter.
		# The second item has a 30% (0.3) chance, when added to the first item, that's 0.7--still less than we rolled and another miss.
		# The third and final example items also has a 30% (0.3) chance. Since the roll is less than 0.7 (our counter) + 0.3 (our final item's chance), it's a hit and we know the thrid item should spawn.
		var item_roll = randf()
		var item_type: ItemData.Type
		var chance_counter: float = 0.0
		for row in distribution.distribution:
			var dist_type = row[0]
			var dist_chance = row[1]
			if item_roll < (chance_counter + dist_chance):
				# Hit! Save the type and stop looping
				item_type = dist_type
				break
			else:
				# Miss! Iterate the chance
				chance_counter += dist_chance
		
		# Spawn the item we rolled to spawn
		if item_type == null: push_warning("Rolled an item spawn but didn't get an item to spawn, ensure distribution chances add up to 1.0 to avoid accidentally lowering spawn chances")
		spawn_item(cell_position, item_type)
		
		#if OS.has_feature('debug'):
			#spawned_items.push_back([cell, get_cell_atlas_coords(cell), cell_position, item_type])
	#if OS.has_feature('debug'): print(spawned_items)

# Determines if an item should spawn in this cell based on a roll against its distance from the spawn anchor and which distance band it lies within
func should_spawn_item(cell_position: Vector2) -> bool:
	var roll = randf()
	var distance_scalar: float
	var cell_distance = cell_position.distance_to(spawn_anchor)
	for distance in distance_bands.keys():
		if cell_distance > distance: distance_scalar = distance_bands[distance]
	var final_spawn_chance = distance_scalar * spawn_scalar
	return roll < final_spawn_chance

func spawn_item(cell_postion: Vector2, item_type: ItemData.Type) -> void:
	var spawn_resource = spawn_dict[item_type]
	assert(spawn_resource != null, "Attempted to spawn item of type %s that is not in the spawn dictionary" % item_type)
	var item_scene = load(spawn_resource) as PackedScene
	var item = item_scene.instantiate() as Node2D
	item.position = cell_postion
	add_child(item)
