class_name HexPathIterator

func _init(id_path: PackedInt64Array, hex_to_id: Dictionary):
	_id_path = id_path
	_hex_by_id = hex_to_id.keys()
	
func _iter_init(iter) -> bool:
	iter[0] = 0
	return iter[0] < _id_path.size()

func _iter_next(iter) -> bool:
	iter[0] += 1
	return iter[0] < _id_path.size()

func _iter_get(iter) -> Vector2i:
	return _hex_by_id[_id_path[iter]]
	
var _id_path: PackedInt64Array
var _hex_by_id: Array
