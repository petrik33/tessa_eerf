class_name teCombatSkillCastUnitComboAttack extends teCombatSkillCastBase


@export var attacks_number: int = 2


func expand(
	unit_id: int,
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	expanded: teCombatExpandedCommand
):
	var cast_target := target as teCombatTargetUnitAndHex
	var unit := state.unit(unit_id)
	if cast_target.hex != unit.hex:
		var movement_path := teCombatPathfinding.path_to_hex(runtime, unit, cast_target.hex)
		expanded.append(teCombatActions.unit_move(unit_id, movement_path))
	for idx in range(attacks_number):
		var context := Context.new()
		context.add(teCombatContext.COMBO_HIT, idx)
		context.add(teCombatContext.COMBO_LENGTH, attacks_number)
		context.add(teCombatContext.ADD_MANA, false)
		expanded.append(teCombatActions.unit_attack(unit_id, target.unit_id), context)


func targeting_mode() -> teCombatTargeting.Mode:
	return teCombatTargeting.Mode.UNIT_AND_LOCATION
