class_name teCombatTargetSelectionSelf extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	assert(context.has(teCombatContext.UNIT_ID))
	return teCombatTargets.unit(context.read(teCombatContext.UNIT_ID))
