class_name HexNavigation extends RefCounted


func set_point_disabled(hex: Vector2i, disabled: bool = true):
	_hex_astar.set_point_disabled(_id_by_hex(hex), disabled)


func is_point_disabled(hex: Vector2i) -> bool:
	return _hex_astar.is_point_disabled(_id_by_hex(hex))


func clear_disabled_points():
	for id in _hex_astar.get_point_ids():
		_hex_astar.set_point_disabled(id, false)


func has_hex(hex: Vector2i) -> bool:
	return _hex_to_id.has(hex)


func get_path(from: Vector2i, to: Vector2i, allow_partial: bool = false) -> Array[Vector2i]:
	var id_path := _hex_astar.get_id_path(_id_by_hex(from), _id_by_hex(to), allow_partial)
	var path: Array[Vector2i] = []
	var path_size := id_path.size()
	path.resize(path_size)
	for idx in range(path_size):
		path[idx] = _hex_by_id(id_path[idx])
	return path


func bfs(from: Vector2i, condition: Callable) -> Array[Vector2i]:
	var queue := [from]
	var came_from: Dictionary[Vector2i, Vector2i] = {}

	while not queue.is_empty():
		var current = queue.pop_front()

		if condition.call(current):
			return _bfs_reconstruct(from, current, came_from)

		for next in HexMath.neighbors_iter(current):
			if not has_hex(next):
				continue
				
			if is_point_disabled(next):
				continue

			if came_from.has(next):
				continue

			came_from[next] = current
			queue.append(next)
	
	return []


func _init(grid: HexGridBase):
	_hex_astar = HexAStar2D.new()
	var hex_id := 0
	for hex in grid.iterator():
		_hex_to_id[hex] = hex_id
		_hex_astar.add_point(hex_id, hex)
		hex_id += 1
	for hex in grid.iterator():
		hex_id = _hex_to_id[hex]
		for neighbor in HexMath.neighbors_iter(hex):
			if not grid.has_point(neighbor):
				continue
			var neighbor_id = _id_by_hex(neighbor)
			if _hex_astar.are_points_connected(hex_id, neighbor_id):
				continue
			_hex_astar.connect_points(hex_id, neighbor_id)


var _hex_astar: HexAStar2D
var _hex_to_id: Dictionary[Vector2i, int]


func _hex_by_id(id: int) -> Vector2i:
	return _hex_to_id.keys()[id]


func _id_by_hex(hex: Vector2i) -> int:
	return _hex_to_id[hex]


func _bfs_reconstruct(from: Vector2i, end: Vector2i, came_from: Dictionary[Vector2i, Vector2i]) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current = end

	while current != from:
		path.push_front(current)
		current = came_from[current]

	return path
	
