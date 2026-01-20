@tool
class_name OddrHexMath extends OffsetHexMathBase

func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	return OffsetHexMath.oddr_neighbor(hex, direction)

func to_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.oddr_to_axial(hex)

func from_axial(hex: Vector2i) -> Vector2i:
	return OffsetHexMath.axial_to_oddr(hex)

func is_layout_compatible(layout: HexLayout) -> bool:
	return HexLayoutMath.is_pointy_top(layout)
