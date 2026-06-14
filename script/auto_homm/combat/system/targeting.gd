class_name teCombatTargeting


func _init() -> void:
	Utils.assert_static_lib()


enum Attack {
	NEAREST,
	LOWEST_HP,
	HIGHEST_THREAT,
	RANDOM,
	FURTHEST,
	FRONTLINE_FIRST,
	INHERIT
}


enum Mode {
	UNIT,
	UNIT_OR_UNITS,
	AREA,
	LOCATION,
	SELF_AOE,
	SELF,
	CONE,
	DIRECTION,
	UNIT_AND_LOCATION,
	INVALID,
}


static func is_valid(target: teCombatTargetBase) -> bool:
	return not target is teCombatTargetInvalid


static func unit_attack(unit_id: int, state: teCombatState) -> int:
	return nearest_unit(unit_id, state)


static func nearest_unit(unit_id: int, state: teCombatState) -> int:
	var best_id := -1
	var best_score := Math.INT_MAX
	var unit := state.unit(unit_id)
	var enemies_id := state.unit_enemies_id(unit_id)

	for other_id in enemies_id:
		var enemy_unit := state.unit(other_id)
		if not enemy_unit.is_alive():
			continue
		var d := HexMath.distance(unit.hex, enemy_unit.hex)
		if d < best_score:
			best_score = d
			best_id = other_id
	
	return best_id


static func target_fits_mode(target: teCombatTargetBase, mode: Mode) -> bool:
	match mode:
		Mode.UNIT:
			return target is teCombatTargetUnit and target.is_single()
		Mode.LOCATION:
			return target is teCombatTargetHex
		Mode.UNIT_AND_LOCATION:
			return target is teCombatTargetUnitAndHex
		Mode.UNIT_OR_UNITS:
			return target is teCombatTargetUnit
	return false
