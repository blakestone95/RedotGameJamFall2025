class_name IDManager extends Node

var nextId: int = 1

# Use this to assign an ID to any object you need to be able to reference by ID, such as pickups or enemies
func get_id():
	var id = nextId
	nextId += 1
	return id
