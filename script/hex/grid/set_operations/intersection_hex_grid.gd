@tool
class_name IntersectionHexGrid extends SetOperationHexGridBase

func iterator() -> HexGridIteratorBase:
	return IntersectionHexGridIterator.new(gridA, gridB)

func has_point(hex: Vector2i) -> bool:
	return gridA.has_point(hex) and gridB.has_point(hex)
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var boundsA := Rect2(Vector2.ZERO, Vector2.ZERO)
	var boundsB := Rect2(Vector2.ZERO, Vector2.ZERO)
	boundsA = gridA.approx_pixel_bounds(layout)
	boundsB = gridB.approx_pixel_bounds(layout)
	return boundsA.intersection(boundsB)
