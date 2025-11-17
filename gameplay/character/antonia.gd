class_name Antonia extends CharacterBody2D

# Attributes
@export var speed = 200

# Audio related  (Stingray)
@onready var footstep_player: AudioStreamPlayer2D = $Footsteps_SFX
const footsteps_dirt = [
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Earth_01.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Earth_02.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Earth_03.wav")
]
const footsteps_grass = [
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Grass_01.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Grass_02.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Grass_03.wav")
]
const footsteps_water = [
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Water_01.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Water_02.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_Water_03.wav")
]
const footsteps_wood = [
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_NormalWood_01.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_NormalWood_02.wav"),
	preload("res://data/audio_assets/sfx/footsteps/Footsteps_Casual_NormalWood_03.wav")
]
var current_material: int = -1

# Inventory related
var inventory: Inventory
## Provide the ItemData resources in the order you want them to appear
@export var inventory_items: Array[ItemData]

# Interactibles
# Separated interactions with pickups and colony so we can prioritize interactions without complex data structure management
var nearby_pickups: Dictionary = {}
var nearby_colony: OverworldColony # There will only be one colony

func _ready() -> void:
	# Set up inventory
	var intentory_data: Dictionary = {}
	for item in inventory_items:
		intentory_data[item.type] = item.duplicate()
	inventory = Inventory.new(intentory_data)

func _physics_process(_delta: float) -> void:
	# Determine direction from inputs
	velocity = Vector2.ZERO
	if Input.is_action_pressed("character_right"):
		velocity.x += 1
	if Input.is_action_pressed("character_left"):
		velocity.x -= 1
	if Input.is_action_pressed("character_down"):
		velocity.y += 1
	if Input.is_action_pressed("character_up"):
		velocity.y -= 1

	# Get velocity and manage animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# Rotate animation to angle of movement
		rotation = velocity.angle() + PI/2
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Move the character
	move_and_slide()
	
	# whats below for audio
	ground_below()


func _process(_delta: float) -> void:
	# Handle interaction
	if Input.is_action_just_pressed("interact"):
		handle_interaction()


func _on_interaction_area_entered(area: Area2D) -> void:
	if area is Pickup:
		nearby_pickups[area.id] = area
	if area is OverworldColony:
		nearby_colony = area


func _on_interaction_area_exited(area: Area2D) -> void:
	if area is Pickup:
		nearby_pickups.erase(area.id)
	if area is OverworldColony:
		nearby_colony = null


func handle_interaction() -> void:
	if nearby_pickups.size() > 0:
		# Handle pickup into inventory
		var pickup: Pickup = nearby_pickups.values()[0]
		assert(pickup is Pickup, "The first nearby pickup is not actually a Pickup class")
		var inventory_slot = inventory.items[pickup.pickup_type]
		var remainder = inventory_slot.increase(1)
		if remainder == 0:
			pickup.pickup()
			nearby_pickups.erase(pickup.id)
		return
	elif nearby_colony != null:
		# Handle inventory deposit
		for item_to_deposit in inventory.items.values():
			if item_to_deposit.count == 0: continue
			# Add current inventory to colony inventory
			var colony_item_bucket = nearby_colony.inventory.items[item_to_deposit.type]
			var remainder = colony_item_bucket.increase(item_to_deposit.count)
			# Update player inventory
			item_to_deposit.decrease(item_to_deposit.count - remainder)
		return

"""
# doesn't work.  Not part of MVP, stretch goal
func ground_below() -> void:
	# written by Stingray
	if velocity.length() < 10: return  #not sure what this does, but it was in the example
	
	# find player position
	var query_pos: Vector2 = global_position
	
	# get all tilemaplayers
	var all_layers: Array[Node] = []
	var root: Node = get_tree().current_scene
	_find_all_tilemap_layers(root, all_layers)
	
	var top_tile_data: TileData = null
	var highest_z: int = -INF
	
	for layer_node in all_layers:
		var layer: TileMapLayer = layer_node as TileMapLayer
		if not layer: continue
		
		var local_pos: Vector2 = layer.to_local(query_pos) # since the layers were scaled up by 4x
		var tile_coords: Vector2i = layer.local_to_map(local_pos)
		var tile_data: TileData = layer.get_cell_tile_data(tile_coords)
		
		if tile_data != null and layer.z_index > highest_z:
			highest_z = layer.z_index
			top_tile_data = tile_data
	
	if top_tile_data == null: return
	
	print("TileSet sources:", layer.tile_set.get_source_count())
	var material: Variant = top_tile_data.get_custom_data('material')
	if material is int and material > 0 and material != current_material:
		play_material_sound(material)
		current_material = material


func play_material_sound(mat: int) -> void:
	var streams: Array[AudioStream]
	
	match mat:
		1: streams = footsteps_dirt
		2: streams = footsteps_grass
		3: streams = footsteps_water
		4: streams = footsteps_wood
		_: return
		
	if streams.is_empty(): return
	
	var random_stream: AudioStream = streams[randi() % streams.size()]
	footstep_player.stream = random_stream
	footstep_player.pitch_scale = randf_range(0.9, 1.1)
	footstep_player.play()


func _find_all_tilemap_layers(node: Node, layers: Array[Node]) -> void:
	if node is TileMapLayer:
		layers.append(node)
	for child in node.get_children():
		_find_all_tilemap_layers(child, layers)
"""
