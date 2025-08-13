@tool
class_name UnionHexGridIterator extends HexGridIteratorBase

var _gridA: HexGridBase
var _gridB: HexGridBase
var _iterated_overA: bool
var _current_iterator: HexGridIteratorBase
var _iteratorA: HexGridIteratorBase
var _iteratorB: HexGridIteratorBase

func _init(gridA: HexGridBase, gridB: HexGridBase):
	_gridA = gridA
	_gridB = gridB

func _iter_init(arg) -> bool:
	_iterated_overA = false
	
	_iteratorA = _gridA.iterator()
	_iteratorB = _gridB.iterator()
	
	if _iteratorA._iter_init(arg):
		_current_iterator = _iteratorA
		return true
		
	_iterated_overA = true
	
	if _iteratorB._iter_init(arg):
		_current_iterator = _iteratorB
		return true
	
	return false

func _iter_next(arg) -> bool:
	while true:
		if _current_iterator._iter_next(arg):
			var hex = _current_iterator._iter_get(arg)
			if _iterated_overA and _gridA.has_point(hex):
				continue
			return true
		else:
			if _iterated_overA:
				return false
			_current_iterator = _iteratorB
			_iterated_overA = true
			if not _iteratorB._iter_init(arg):
				return false
	
	# Unreachable
	return false

func _iter_get(arg) -> Vector2i:
	return _current_iterator._iter_get(arg)
