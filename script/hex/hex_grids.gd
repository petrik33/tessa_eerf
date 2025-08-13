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

static func ranged(offset: Vector2i, base_grid: HexGridBase, range: int, include_center: bool = true) -> HexGridBase:
	var hexagonalGrid = HexagonalHexGrid.new(range)
	var offsetRangeGrid = OffsetHexGrid.new(hexagonalGrid, offset)
	var result_grid = IntersectionHexGrid.new(base_grid, offsetRangeGrid)
	if include_center:
		return result_grid
	return subtract(result_grid, point(offset))
	
static func subtract(gridA : HexGridBase, gridB : HexGridBase) -> HexGridBase:
		return SubtractionHexGrid.new(gridA, gridB)
