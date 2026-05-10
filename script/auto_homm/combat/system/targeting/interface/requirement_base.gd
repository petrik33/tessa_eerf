@abstract
class_name teCombatTargetRequirementBase extends Resource


@abstract
func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	context: Context
) -> bool


@abstract
func is_valid_for(targeting_mode: teCombatTargeting.Mode) -> bool
