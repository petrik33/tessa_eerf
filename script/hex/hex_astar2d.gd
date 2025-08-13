class_name HexAStar2D extends AStar2D

func _compute_cost(u: int, v: int):
	var u_pos = get_point_position(u)
	var v_pos = get_point_position(v)
	return HexMath.distance(Vector2i(u_pos), Vector2i(v_pos))

func _estimate_cost(u: int, v: int):
	return _compute_cost(u, v)
