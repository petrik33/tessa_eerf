class_name teCombatTargetingBfsHexIter extends teCombatTargetHexQueryBase.Iter


var grid: HexGridBase
var queue: Array[Vector2i] = []
var visited: Dictionary[Vector2i, bool] = {}


func _init(_grid: HexGridBase, from: Vector2i):
	grid = _grid.duplicate()
	queue.push_back(from)
	visited[from] = true


func should_continue() -> bool:
	return not queue.is_empty()


func _iter_init(_arg) -> bool:
	return should_continue()


func _iter_next(_arg) -> bool:
	var current_hex: Vector2i = queue.pop_front()
	for neighbor in HexMath.neighbors_iter(current_hex):
		if not grid.has_point(neighbor):
			continue
		if visited.has(neighbor):
			continue
		queue.append(neighbor)
		visited[neighbor] = true
	return should_continue()


func _iter_get(_arg) -> teCombatTargetHex:
	return teCombatTargets.hex(queue[0])
