@abstract
class_name teCombatSkillCastBase extends Resource


@abstract
func resolve(
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
)

@abstract
func targeting_mode() -> teCombatTargeting.Mode
