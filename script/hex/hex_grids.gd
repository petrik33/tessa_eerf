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

static func ranged(offset: Vector2i, range: int, base_grid: HexGridBase, include_center: bool = true) -> HexGridBase:
	var range_grid = HexagonalHexGrid.new(range)
	range_grid = OffsetHexGrid.new(range_grid, offset)
	range_grid = IntersectionHexGrid.new(base_grid, range_grid)
	if include_center:
		return range_grid
	return subtract(range_grid, point(offset))

static func intersection(gridA: HexGridBase, gridB: HexGridBase) -> IntersectionHexGrid:
	return IntersectionHexGrid.new(gridA, gridB)
	
static func subtract(gridA : HexGridBase, gridB : HexGridBase) -> HexGridBase:
		return SubtractionHexGrid.new(gridA, gridB)
