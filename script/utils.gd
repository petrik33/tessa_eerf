@tool
class_name Utils

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

static func to_typed(type: int, array: Array):
	return Array(array, type, "", null)
