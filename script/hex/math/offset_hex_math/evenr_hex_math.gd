@tool
class_name EvenrHexMath extends OffsetHexMathBase

func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	return OffsetHexMath.evenr_neighbor(hex, direction)

func to_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.evenr_to_axial(hex)
	
func from_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.axial_to_evenr(hex)

func is_layout_compatible(layout: HexLayout) -> bool:
	return HexLayoutMath.is_pointy_top(layout)
	
func layout_error_message(_layout: HexLayout) -> String:
	return "Even-R hex math requires pointy-topped layout."
