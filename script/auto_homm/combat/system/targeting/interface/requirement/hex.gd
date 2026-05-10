@abstract
class_name teCombatTargetHexRequirementBase extends teCombatTargetRequirementBase


@abstract func hex_fits(
	hex: Vector2i,
	state: teCombatState,
	context: Context
) -> bool


func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	context: Context
) -> bool:
	var hex_target = target as teCombatTargetHex
	return hex_fits(hex_target.hex, state, context)


func is_valid_for(targeting_mode: teCombatTargeting.Mode) -> bool:
	return targeting_mode == teCombatTargeting.Mode.LOCATION
