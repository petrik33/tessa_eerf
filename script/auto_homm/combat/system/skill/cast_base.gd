@abstract
class_name teCombatSkillCastBase extends Resource


@abstract
func expand(
	unit_id: int,
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	expanded: teCombatExpandedCommand
)

@abstract
func targeting_mode() -> teCombatTargeting.Mode
