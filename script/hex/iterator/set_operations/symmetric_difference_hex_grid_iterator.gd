@tool
class_name SymmetricDifferenceHexGridIterator extends HexGridIteratorBase

var _gridA: HexGridBase
var _gridB: HexGridBase
var _current_iterator: HexGridIteratorBase
var _iteratorA: HexGridIteratorBase
var _iteratorB: HexGridIteratorBase
var _iterated_overA: bool

func _init(gridA: HexGridBase, gridB: HexGridBase):
	_gridA = gridA
	_gridB = gridB

func _iter_init(arg) -> bool:
	_iteratorA = _gridA.iterator()
	_iteratorB = _gridB.iterator()
	_iterated_overA = false
	
	if _iteratorA._iter_init(arg):
		_current_iterator = _iteratorA
		return true
	
	_iterated_overA = true
	
	if _iteratorB._iter_init(arg):
		_current_iterator = _iteratorB
		return true
	
	return false

func _iter_next(arg) -> bool:
	return _find_next_symmetric_difference(arg)

func _iter_get(arg) -> Vector2i:
	return _current_iterator._iter_get(arg)

func _find_next_symmetric_difference(arg) -> bool:
	while true:
		if _current_iterator._iter_next(arg):
			var hex = _current_iterator._iter_get(arg)
			if not _iterated_overA:
				if not _gridB.has_point(hex):
					return true
			else:
				if not _gridA.has_point(hex):
					return true
		else:
			if _iterated_overA:
				return false
			_iterated_overA = true
			_current_iterator = _iteratorB
			if not _iteratorB._iter_init(arg):
				return false
			
	# Unreachable
	return false
