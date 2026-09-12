class_name teCombatTargetQueryEnemies extends teCombatTargetQueryBase


func iter(state: teCombatState, unit_id: int) -> teCombatTargetQueryBase.Iter:
	return teCombatTargetingUnitIter.new(
		state.enemies_id(state.unit_team_id(unit_id))
	)
