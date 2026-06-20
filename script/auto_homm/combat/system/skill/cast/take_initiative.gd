class_name teCombatSkillCastTakeInitiative extends teCombatSkillCastBase


func resolve(
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
):
	var unit_target := target as teCombatTargetUnit
	resolved.emit(teCombatEvents.initiative_taken(unit_target.single()))


func targeting_mode() -> teCombatTargeting.Mode:
	return teCombatTargeting.Mode.UNIT_OR_UNITS
