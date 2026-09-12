@abstract
class_name teCombatTargetRequirementBase extends Resource


@abstract
func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	unit_id: int
) -> bool


@abstract
func is_valid_for(targeting_mode: teCombatTargeting.Mode) -> bool
