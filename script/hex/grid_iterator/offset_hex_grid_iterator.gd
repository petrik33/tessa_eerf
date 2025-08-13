@tool
class_name OffsetHexGridIterator extends HexGridIteratorBase

var _grid: HexGridBase
var _offset: Vector2i
var _iterator: HexGridIteratorBase

func _init(grid: HexGridBase, offset: Vector2i):
	_grid = grid
	_offset = offset

func _iter_init(arg) -> bool:
	_iterator = _grid.iterator()
	return _iterator._iter_init(arg)

func _iter_next(arg) -> bool:
	return _iterator._iter_next(arg)

func _iter_get(arg) -> Vector2i:
	return _iterator._iter_get(arg) + _offset
