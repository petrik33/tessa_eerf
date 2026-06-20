class_name teCombatUnitSkill extends Resource


@export var cast: teCombatSkillCastBase
@export var selection: teCombatTargetSelectionBase
@export var ends_turn: bool = true


func find_target(
	unit_id: int,
	state: teCombatState,
	runtime: teCombatRuntime
) -> teCombatTargetBase:
	var context := Context.new()
	context.add(teCombatContext.UNIT_ID, unit_id)
	context.add(teCombatContext.TEAM_ID, state.unit_team_id(unit_id))
	return selection.first_target(state, runtime, context)


func resolve(
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
):
	if not teCombatTargeting.target_fits_mode(target, cast.targeting_mode()):
		return
	cast.resolve(target, state, runtime, resolved)
