@abstract
class_name teCombatTargetUnitRequirementBase extends teCombatTargetRequirementBase


@abstract
func unit_fits(
	unit: teCombatUnitState,
	state: teCombatState,
	id: int,
	context: Context
) -> bool


func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	context: Context
) -> bool:
	var unit_target := target as teCombatTargetUnit
	return unit_fits(
		state.unit(unit_target.unit_id),
		state,
		unit_target.unit_id,
		context
	)


func is_valid_for(targeting_mode: teCombatTargeting.Mode) -> bool:
	return targeting_mode == teCombatTargeting.Mode.UNIT
