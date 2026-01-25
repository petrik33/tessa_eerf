@tool
class_name acMovement


func _init() -> void:
	assert(false, "Can't be constructed")


static func pick_next_hex(unit: acUnitState, target: acUnitState, state: acBattleState) -> Vector2i:
	var best_hex := unit.hex
	var best_dist := Math.INT_MAX

	for dir in HexMath.NEIGHBOR_DIRECTION:
		var candidate := unit.hex + dir
		if not state.board.is_walkable(candidate):
			continue

		var d := HexMath.distance(candidate, target.hex)
		if d < best_dist:
			best_dist = d
			best_hex = candidate

	return best_hex
