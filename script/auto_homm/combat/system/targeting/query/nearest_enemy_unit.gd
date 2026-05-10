class_name teCombatTargetQueryNearestEnemyUnit extends teCombatTargetUnitQueryBase


func iter(state: teCombatState, context: Context) -> teCombatTargetUnitQueryBase.Iter:
	assert(context.has(teCombatContext.UNIT_ID))
	var unit_id = context.read(teCombatContext.UNIT_ID)
	return teCombatTargetingNearestUnitIter.new(
		state, 
		state.enemies_id(state.unit_team_id(unit_id)),
		unit_id
	)
