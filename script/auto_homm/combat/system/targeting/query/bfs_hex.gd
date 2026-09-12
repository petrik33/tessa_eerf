class_name teCombatTargetQueryBfsHex extends teCombatTargetQueryBase


func iter(state: teCombatState, unit_id: int) -> teCombatTargetQueryBase.Iter:
	var unit := state.unit(unit_id)
	return teCombatTargetingBfsHexIter.new(state.map.grid, unit.hex)
