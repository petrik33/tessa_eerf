@tool
class_name SubtractionHexGridIterator extends HexGridIteratorBase

var _gridA: HexGridBase
var _gridB: HexGridBase
var _iteratorA: HexGridIteratorBase
var _current_hex: Vector2i

func _init(gridA: HexGridBase, gridB: HexGridBase):
	_gridA = gridA
	_gridB = gridB

func _iter_init(arg) -> bool:
	_iteratorA = _gridA.iterator()
	var init = _iteratorA._iter_init(arg)
	if not init:
		return false
	_current_hex = _iteratorA._iter_get(arg)
	if not _gridB.has_point(_current_hex):
		return true
	return _find_next_subtraction(arg)

func _iter_next(arg) -> bool:
	return _find_next_subtraction(arg)

func _iter_get(_arg) -> Vector2i:
	return _current_hex

func _find_next_subtraction(arg) -> bool:
	while _iteratorA._iter_next(arg):
		var hex = _iteratorA._iter_get(arg)
		if not _gridB.has_point(hex):
			_current_hex = hex
			return true
	return false
