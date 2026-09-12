@abstract
class_name teCombatTargeHexPriorityBase extends teCombatTargetPriorityBase


@abstract func is_hex_prior(
	state: teCombatState,
	unit_id: int,
	hexA: Vector2,
	hexB: Vector2
) -> bool


func is_prior(
	state: teCombatState,
	unit_id: int,
	targetA: teCombatTargetBase,
	targetB: teCombatTargetBase
) -> bool:
	assert(targetA is teCombatTargetHex and targetB is teCombatTargetHex)
	var hexA := (targetA as teCombatTargetHex).hex
	var hexB := (targetB as teCombatTargetHex).hex
	return is_hex_prior(state, unit_id, hexA, hexB)
