@tool
class_name EvenqHexMath extends OffsetHexMathBase

func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	return OffsetHexMath.evenq_neighbor(hex, direction)

func to_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.evenq_to_axial(hex)

func from_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.axial_to_evenq(hex)

func is_layout_compatible(layout: HexLayout) -> bool:
	return HexLayoutMath.is_flat_top(layout)
