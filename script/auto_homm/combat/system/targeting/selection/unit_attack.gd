class_name teCombatTargetSelectionUnitAttack extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	assert(context.has(teCombatContext.UNIT_ID))
	var unit_id = context.read(teCombatContext.UNIT_ID)
	var unit := state.unit(unit_id)
	var enemy_id := teCombatTargeting.unit_attack(unit_id, state)
	var enemy := state.unit(enemy_id)
	if unit.in_attack_range(enemy):
		return teCombatTargets.unit_and_hex(enemy_id, unit.hex)
	var path := teCombatPathfinding.path_to_attack(runtime, unit, enemy)
	if not path.is_valid() or path.length() > unit.stats.movement_range:
		return teCombatTargets.invalid()
	return teCombatTargets.unit_and_hex(enemy_id, path.destination())
