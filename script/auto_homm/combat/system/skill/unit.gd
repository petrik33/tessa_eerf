class_name teCombatUnitSkill extends Resource


@export var cast: teCombatSkillCastBase
@export var selection: teCombatTargetSelectionBase


func find_target(
	unit_id: int,
	state: teCombatState,
	runtime: teCombatRuntime
) -> teCombatTargetBase:
	var context := Context.new()
	context.add(teCombatContext.UNIT_ID, unit_id)
	return selection.first_target(state, runtime, context)


func expand(
	unit_id: int,
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	expanded: teCombatExpandedCommand
):
	if not teCombatTargeting.target_fits_mode(target, cast.targeting_mode()):
		expanded.invalidate()
		return
	cast.expand(unit_id, target, state, runtime, expanded)
