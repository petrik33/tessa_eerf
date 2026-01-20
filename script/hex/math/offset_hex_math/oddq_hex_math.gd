@tool
class_name OddqHexMath extends OffsetHexMathBase

func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	return OffsetHexMath.oddq_neighbor(hex, direction)

func to_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.oddq_to_axial(hex)

func from_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.axial_to_oddq(hex)

func is_layout_compatible(layout: HexLayout) -> bool:
	return HexLayoutMath.is_flat_top(layout)
