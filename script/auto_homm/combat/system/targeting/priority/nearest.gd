class_name teCombatTargetUnitPriorityNearest extends teCombatTargetUnitPriorityBase


func is_unit_prior(
	state: teCombatState,
	unit_id: int,
	targetA_id: int,
	targetB_id: int
) -> bool:
	var unit_hex := state.unit(unit_id).hex
	var hexA := state.unit(targetA_id).hex
	var hexB := state.unit(targetB_id).hex
	return HexMath.distance(unit_hex, hexA) < HexMath.distance(unit_hex, hexB)
