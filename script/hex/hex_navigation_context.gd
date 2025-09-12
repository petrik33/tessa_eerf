class_name HexNavigationContext


var grid: HexGridBase


func hex(id: int) -> Vector2i:
	return _hex_to_id.keys()[id]


func id(hex: Vector2i) -> int:
	return _hex_to_id[hex]


func path(id_path: PackedInt64Array) -> Array[Vector2i]:
	var hex_path: Array[Vector2i] = []
	hex_path.resize(id_path.size())
	var idx = 0
	for _hex in path_iterator(id_path):
		hex_path[idx] = _hex
		idx += 1
	return hex_path


func path_iterator(id_path: PackedInt64Array) -> HexPathIterator:
	return HexPathIterator.new(id_path, _hex_to_id)


var _hex_to_id: Dictionary[Vector2i, int]


func _init(_grid: HexGridBase) -> void:
	grid = _grid
	var hex_id = 0
	for grid_hex in grid.iterator():
		_hex_to_id[grid_hex] = hex_id
		hex_id += 1
	hex_id = 0
