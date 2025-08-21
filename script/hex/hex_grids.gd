@tool
class_name HexGrids

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

static func point(hex: Vector2i) -> HexGridBase:
	var grid = PointListHexGrid.new()
	grid.points.append(hex)
	return grid

static func points(_points: Array[Vector2i]) -> HexGridBase:
	var grid = PointListHexGrid.new()
	grid.points = _points.duplicate()
	return grid

static func ranged(offset: Vector2i, range: int, include_center: bool = true) -> HexGridBase:
	var hexagonalGrid = HexagonalHexGrid.new(range)
	var offsetRangeGrid = OffsetHexGrid.new(hexagonalGrid, offset)
	if include_center:
		return offsetRangeGrid
	return subtract(offsetRangeGrid, point(offset))

static func intersection(gridA: HexGridBase, gridB: HexGridBase) -> IntersectionHexGrid:
	return IntersectionHexGrid.new(gridA, gridB)
	
static func subtract(gridA : HexGridBase, gridB : HexGridBase) -> HexGridBase:
		return SubtractionHexGrid.new(gridA, gridB)
