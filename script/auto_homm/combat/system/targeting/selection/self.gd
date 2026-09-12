class_name teCombatTargetSelectionSelf extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, unit_id: int) -> teCombatTargetBase:
	return teCombatTargets.unit(unit_id)
