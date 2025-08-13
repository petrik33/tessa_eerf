@tool
class_name PointListHexGridIterator extends HexGridIteratorBase

var _points: Array[Vector2i]
var _index: int

func _init(points: Array[Vector2i]):
	_points = points.duplicate()  # Create a copy to prevent external modification

func _iter_init(arg) -> bool:
	_index = 0
	return not _points.is_empty()

func _iter_next(_arg) -> bool:
	_index += 1
	return _index < _points.size()

func _iter_get(_arg) -> Vector2i:
	return _points[_index]
