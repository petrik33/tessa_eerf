@abstract
class_name teCombatTargetUnitRequirementBase extends teCombatTargetRequirementBase


@abstract
func unit_fits(
	target_unit: teCombatUnitState,
	state: teCombatState,
	unit_id: int,
	target_id: int
) -> bool


func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	unit_id: int
) -> bool:
	var unit_target := target as teCombatTargetUnit
	return unit_fits(
		state.unit(unit_target.unit_id),
		state,
		unit_id,
		unit_target.unit_id
	)


func is_valid_for(targeting_mode: teCombatTargeting.Mode) -> bool:
	return targeting_mode == teCombatTargeting.Mode.UNIT
