@tool
class_name SpiralHexGridIterator extends HexGridIteratorBase

var _radius: int
var _current_ring: int
var _current_direction: int
var _current_segment_step: int

func _init(radius: int):
	_radius = radius

func _iter_init(_arg) -> bool:
	_current_ring = 0
	_current_direction = HexLayoutMath.CORNER_NUM - 1 # So that first ring finishes in 1 iteration
	_current_segment_step = 0
	return _in_bounds()

func _iter_next(_arg) -> bool:
	_current_segment_step += 1
	if _current_segment_step >= _current_ring:
		_current_segment_step = 0
		_current_direction += 1
	if _current_direction >= HexLayoutMath.CORNER_NUM:
		_current_direction = 0
		_current_segment_step = 0
		_current_ring += 1
	return _in_bounds()

func _iter_get(_arg) -> Vector2i:
	var segment_start := HexMath.in_direction(_current_direction, _current_ring)
	var segment_steps := HexMath.in_direction((_current_direction + 2) % 6, _current_segment_step)
	return segment_start + segment_steps

func _in_bounds() -> bool:
	return _current_ring <= _radius
