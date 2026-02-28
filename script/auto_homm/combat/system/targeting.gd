class_name teCombatTargeting


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


enum Mode {
	NEAREST,
	LOWEST_HP,
	HIGHEST_THREAT,
	RANDOM,
	FURTHEST,
	FRONTLINE_FIRST
}


static func find(unit_id: int, combat: teCombatState) -> int:
	var best := -1
	var best_score := Math.INT_MAX
	var unit := combat.unit(unit_id)
	var enemies_id := combat.enemies_id(unit_id)

	for other_id in enemies_id:
		var enemy_unit := combat.unit(other_id)
		if not enemy_unit.is_alive():
			continue
		var d := HexMath.distance(unit.hex, enemy_unit.hex)
		if d < best_score:
			best_score = d
			best = other_id
	return best
