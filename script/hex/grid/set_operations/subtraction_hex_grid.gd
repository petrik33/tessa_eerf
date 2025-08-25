@tool
class_name SubtractionHexGrid extends SetOperationHexGridBase

func iterator() -> HexGridIteratorBase:
	return SubtractionHexGridIterator.new(gridA, gridB)

func has_point(hex: Vector2i) -> bool:
	return gridA.has_point(hex) and (not gridB.has_point(hex))
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	return gridA.approx_pixel_bounds(layout)
