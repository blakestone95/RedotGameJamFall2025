class_name SpawnDistribution extends Resource

## Array of arrays specifying item type and the relative distribution scalar (aka spawn chance).
## Each entry should look like this: [code][ItemData.Type.<item>, 0.0][/code].
## Spawn chances should sum to 1.0 across all entries and any further spawn rate adjustments should 
## be performed by adjusting the distance bands and spawn scalar on the TileMapSpawner instance.
@export var distribution: Array = [
	[ItemData.Type.LEAF, 0.3],
	[ItemData.Type.STICK, 0.3],
	[ItemData.Type.PEBBLE, 0.1],
	[ItemData.Type.FOOD, 0.3],
]
