class_name teCombatTargetQueryBfsFromUnitHex extends teCombatTargetHexQueryBase


func iter(state: teCombatState, context: Context) -> teCombatTargetHexQueryBase.Iter:
	assert(context.has(teCombatContext.UNIT_ID))
	var unit := state.unit(context.read(teCombatContext.UNIT_ID))
	return teCombatTargetingBfsHexIter.new(state.map.grid, unit.hex)
