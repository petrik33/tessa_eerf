@tool
class_name ParallelogramHexGridIterator extends HexGridIteratorBase

var _origin: Vector2i
var _size: Vector2i
var _axis_pair: HexMath.AxisPair
var _ab_delta: Vector2i


func _init(origin: Vector2i, size: Vector2i, axis_pair: HexMath.AxisPair):
	_origin = origin
	_size = size
	_axis_pair = axis_pair


func _iter_init(_arg) -> bool:
	_ab_delta = Vector2i.ZERO
	return _size.x > 0 or _size.y > 0


func _iter_next(_arg) -> bool:
	_ab_delta.x += 1
	if _ab_delta.x >= _size.x:
		_ab_delta.x = 0
		_ab_delta.y += 1
	return _ab_delta.y < _size.y


func _iter_get(_arg) -> Vector2i:
	return _origin + HexMath.from_ab(_ab_delta, _axis_pair)
