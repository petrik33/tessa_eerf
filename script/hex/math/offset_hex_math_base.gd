@tool
class_name OffsetHexMathBase extends Resource

func neighbor(_hex: Vector2i, _direction: int) -> Vector2i:
	assert(false, "neighbor() must be implemented")
	return Vector2i()

func to_axial(_hex: Vector2i) -> Vector2i:
	assert(false, "to_axial() must be implemented")
	return Vector2i()
	
func from_axial(_hex: Vector2i) -> Vector2i:
	assert(false, "to_axial() must be implemented")
	return Vector2i()

func is_layout_compatible(_layout: HexLayout) -> bool:
	assert(false, "is_layout_compatible() must be implemented")
	return false
	
func layout_error_message(_layout: HexLayout) -> String:
	return "This layout is not compatible with this hex math implementation."
