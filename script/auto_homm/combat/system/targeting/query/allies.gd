class_name teCombatTargetQueryAllies extends teCombatTargetQueryBase


func iter(state: teCombatState, unit_id: int) -> teCombatTargetQueryBase.Iter:
	return teCombatTargetingUnitIter.new(
		state.allies_id(state.unit_team_id(unit_id))
	)
