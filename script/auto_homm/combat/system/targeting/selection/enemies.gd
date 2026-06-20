class_name teCombatTargetSelectionEnemies extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	assert(context.has(teCombatContext.TEAM_ID))
	var team_id = context.read(teCombatContext.TEAM_ID)
	var enemies := state.enemies_id(team_id)
	return teCombatTargets.units(enemies)
