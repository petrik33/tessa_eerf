@tool
class_name UnionHexGrid extends SetOperationHexGridBase

func iterator() -> HexGridIteratorBase:
	return UnionHexGridIterator.new(gridA, gridB)

func has_point(hex: Vector2i) -> bool:
	return gridA.has_point(hex) or gridB.has_point(hex)
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var bounds := Rect2(Vector2.ZERO, Vector2.ZERO)
	bounds = gridA.approx_pixel_bounds(layout)
	if not bounds.has_area():
		bounds = gridB.approx_pixel_bounds(layout)
	else:
		bounds = bounds.merge(gridB.approx_pixel_bounds(layout))
	return bounds
