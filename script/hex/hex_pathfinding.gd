class_name HexPathfinding


func set_point_disabled(hex: Vector2i, disabled: bool = true):
	_hex_astar.set_point_disabled(_context.id(hex), disabled)


func is_point_disabled(hex: Vector2i) -> bool:
	return _hex_astar.is_point_disabled(_context.id(hex))


func clear_disabled_points():
	for id in _hex_astar.get_point_ids():
		_hex_astar.set_point_disabled(id, false)


func id_path(from: Vector2i, to: Vector2i, allow_partial_path: bool = false) -> PackedInt64Array:
	return _hex_astar.get_id_path(_context.id(from), _context.id(to), allow_partial_path)


func _init(context: HexNavigationContext):
	_context = context
	_hex_astar = HexAStar2D.new()
	var grid = _context.grid
	for hex in grid.iterator():
		_hex_astar.add_point(_context.id(hex), hex)
	for hex in grid.iterator():
		var hex_id = _context.id(hex)
		for dir in HexMath.NEIGHBOR_DIRECTION:
			var neighbor = hex + dir
			if not grid.has_point(neighbor):
				continue
			var neighbor_id = _context.id(neighbor)
			if _hex_astar.are_points_connected(hex_id, neighbor_id):
				continue
			_hex_astar.connect_points(hex_id, neighbor_id)

var _hex_astar: HexAStar2D
var _context: HexNavigationContext
