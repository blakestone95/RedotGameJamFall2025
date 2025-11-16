class_name Antonia extends CharacterBody2D

# Attributes
@export var speed = 200

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
