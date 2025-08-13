@tool
class_name HexGridIteratorBase

func _iter_init(_arg) -> bool:
	return false

func _iter_next(_arg) -> bool:
	return false

func _iter_get(_arg) -> Vector2i:
	assert(false, "not implemented")
	return Vector2i()
