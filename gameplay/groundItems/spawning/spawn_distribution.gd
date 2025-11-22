class_name SpawnDistribution extends Resource

## Array SpawnChance specifying the scene to spawn and the relative distribution scalar (aka spawn chance).
## Spawn chances should sum to 1.0 across all entries and any further spawn rate adjustments should 
## be performed by adjusting the distance bands and spawn scalar on the TileMapSpawner instance.
@export var distribution_table: Array[SpawnChance] = []
