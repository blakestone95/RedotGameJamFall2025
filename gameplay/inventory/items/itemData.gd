class_name ItemData
extends Resource

enum Type {LEAF, STICK, FOOD}

@export var type: Type
@export var name: String
@export var texture: Texture2D
var count = 0
@export var max_amount: int

func increase(amount: int):
	count = min(max_amount, count + amount)
	
func decrease(amount: int):
	count = max(0, count - amount)
