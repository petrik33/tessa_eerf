@tool
class_name RectangleHexGridIterator extends HexGridIteratorBase

var _bounds: Rect2i
var _math: OffsetHexMathBase
var _current_hex: Vector2i

func _init(bounds: Rect2i, math: OffsetHexMathBase):
	_bounds = bounds
	_math = math

func _iter_init(_arg) -> bool:
	_current_hex = _bounds.position
	return _in_bounds() and _math != null

func _iter_next(_arg) -> bool:
	_current_hex.x += 1
	if not _in_bounds():
		_current_hex.x = _bounds.position.x
		_current_hex.y += 1
	return _in_bounds()

func _iter_get(_arg) -> Vector2i:
	return _math.to_axial(_current_hex)

func _in_bounds() -> bool:
	return _bounds.has_point(_current_hex)
