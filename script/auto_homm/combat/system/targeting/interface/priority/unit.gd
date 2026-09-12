@abstract
class_name teCombatTargetUnitPriorityBase extends teCombatTargetPriorityBase


@abstract func is_unit_prior(
	state: teCombatState,
	unit_id: int,
	targetA_id: int,
	targetB_id: int
) -> bool


func is_prior(
	state: teCombatState,
	unit_id: int,
	targetA: teCombatTargetBase,
	targetB: teCombatTargetBase
) -> bool:
	assert(targetA is teCombatTargetUnit and targetB is teCombatTargetUnit)
	var targetA_id := (targetA as teCombatTargetUnit).single()
	var targetB_id := (targetB as teCombatTargetUnit).single()
	return is_unit_prior(state, unit_id, targetA_id, targetB_id)
