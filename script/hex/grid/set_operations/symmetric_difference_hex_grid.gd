@tool
class_name SymmetricDifferenceHexGrid extends HexGridBase

@export var gridA: HexGridBase
@export var gridB: HexGridBase

func iterator() -> HexGridIteratorBase:
	return SymmetricDifferenceHexGridIterator.new(gridA, gridB)

func has_point(hex: Vector2i) -> bool:
	var inA = gridA.has_point(hex)
	var inB = gridB.has_point(hex)
	return (inA or inB) and (not (inA and inB))
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var bounds = gridA.approx_pixel_bounds(layout)
	if not bounds.has_area():
		bounds = gridB.approx_pixel_bounds(layout)
	else:
		bounds = bounds.merge(gridB.approx_pixel_bounds(layout))
	return bounds
