class_name Antonia extends CharacterBody2D

# Attributes
## Speed in pixels/second
@export var speed = 300
## For i-frames
var immune: bool = false
var i_frame_time: float = 1.0

var game: Game

# Audio related  (Stingray)
@onready var footstep_player: AudioStreamPlayer2D = $Footsteps_SFX
@onready var pickup_sfx: AudioStreamPlayer2D = $Pickup_SFX
@onready var dropoff_sfx: AudioStreamPlayer2D = $Dropoff_SFX
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

@export var health_bar : AntoniaHealthBar

# Interactibles
# Separated interactions with pickups and colony so we can prioritize interactions without complex data structure management
var nearby_pickups: Dictionary = {}
var nearby_colony: OverworldColony # There will only be one colony
var nearby_breakable: Dictionary = {}

func _ready() -> void:
	# Set up inventory
	var inventory_data: Dictionary = {}
	for item in inventory_items:
		inventory_data[item.type] = item.duplicate()
	inventory = Inventory.new(inventory_data)

func _enter_tree() -> void:
	# Get the game node so we can access the inventory
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
	
	apply_upgrades()

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
	# ground_below()


func _process(_delta: float) -> void:
	# Handle interaction
	if Input.is_action_just_pressed("interact"):
		handle_interaction()
	if Input.is_action_pressed("break") and velocity == Vector2.ZERO:
		handle_break(_delta)

func _on_interaction_area_entered(area: Area2D) -> void:
	if area is Pickup:
		nearby_pickups[area.id] = area
	if area is OverworldColony:
		nearby_colony = area
	if area is ItemToBreak:
		nearby_breakable[area.id] = area

func _on_interaction_area_exited(area: Area2D) -> void:
	if area is Pickup:
		nearby_pickups.erase(area.id)
	if area is OverworldColony:
		nearby_colony = null
	if area is ItemToBreak:
		nearby_breakable.erase(area.id)

func take_damage(damage: int) -> void:
	if !immune:
		health_bar.take_damage(damage)
		$AnimationPlayer.play("iframe")
		immune = true
		await get_tree().create_timer(i_frame_time).timeout
		immune = false

func handle_interaction() -> void:
	if nearby_pickups.size() > 0:
		# Handle pickup into inventory
		var pickup: Pickup = nearby_pickups.values()[0]
		assert(pickup is Pickup, "The first nearby pickup is not actually a Pickup class")
		pickup_item(pickup)
		return
	elif nearby_colony != null:
		# Handle inventory deposit
		deposit_items(nearby_colony.inventory)
		return

func pickup_item(pickup: Pickup) -> void:
	var inventory_slot = inventory.items[pickup.pickup_type]
	var num_to_pickup = 1
	if game.colony_upgrades[Colony.Rooms.HOUSES] and Util.roll_with_chance(.5):
		num_to_pickup += 1
	var remainder = inventory_slot.increase(num_to_pickup)
	# If we picked up anything, we need to remove the pickup so people can't try to pick up multiple times
	if remainder != num_to_pickup:
		pickup_sfx.play()
		pickup.pickup()
		nearby_pickups.erase(pickup.id)

func deposit_items(into: Inventory):
	dropoff_sfx.play()
	for item_to_deposit in inventory.items.values():
		if item_to_deposit.count == 0: continue
		# Add current inventory to colony inventory
		var item_bucket = into.items[item_to_deposit.type]
		var remainder = item_bucket.increase(item_to_deposit.count)
		# Update player inventory
		item_to_deposit.decrease(item_to_deposit.count - remainder)

func handle_break(amount: float) -> void:
	if nearby_breakable.size() > 0:
		# Handle pickup into inventory
		var breakable: ItemToBreak = nearby_breakable.values()[0]
		assert(breakable is ItemToBreak, "The first nearby breakable is not actually a ItemToBreak class")
		breakable.breaking_progress(amount)

func apply_upgrades() -> void:
	# Speed increase
	if game.colony_upgrades[Colony.Rooms.SCOUT]:
		speed *= 1.25
	
	# Storage increase
	if game.colony_upgrades[Colony.Rooms.STORAGE]:
		inventory.items[ItemData.Type.LEAF].max_amount += 2
		inventory.items[ItemData.Type.STICK].max_amount += 2
		inventory.items[ItemData.Type.PEBBLE].max_amount += 1
		inventory.items[ItemData.Type.FOOD].max_amount += 2
	
	# Health increase
	if game.colony_upgrades[Colony.Rooms.GUARD]:
		pass # TODO: Hook up to health system when implemented
	
	# Pickup increase - handled in pickup_item function

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



		
