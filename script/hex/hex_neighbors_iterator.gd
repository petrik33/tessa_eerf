class_name HexNeighborsIterator

var _hex: Vector2i
var _neighbor: int

func _init(hex: Vector2i):
	_hex = hex

func _iter_init(_arg) -> bool:
	_neighbor = 0
	return true

func _iter_next(_arg) -> bool:
	_neighbor += 1
	return _neighbor < HexMath.NEIGHBOR_DIRECTION.size()

func _iter_get(_arg) -> Vector2i:
	return _hex + HexMath.NEIGHBOR_DIRECTION[_neighbor]
