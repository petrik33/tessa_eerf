class_name teCombatTargetSpecification extends Resource


@export var requirements: Array[teCombatTargetRequirementBase]


func fits(
	target: teCombatTargetBase,
	state: teCombatState,
	requester: teCombatTargetRequesterBase
) -> bool:
	for requirement in requirements:
		if not requirement.fits(target, state, requester):
			return false
	return true


func is_valid(targeting_mode: teCombatTargeting.Mode, requester: teCombatTargetRequesterBase) -> bool:
	for requirement in requirements:
		if not requirement.is_valid_for(targeting_mode):
			return false
		if not requirement.can_request(requester):
			return false
	return true
