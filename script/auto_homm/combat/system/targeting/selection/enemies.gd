class_name teCombatTargetSelectionEnemies extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	assert(context.has(teCombatContext.UNIT_ID))
	var unit_id = context.read(teCombatContext.UNIT_ID)
	var enemies := state.unit_enemies_id(unit_id)
	return teCombatTargets.units(enemies)
