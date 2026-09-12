class_name teCombatTargetSpecification extends Resource


@export var requirements: Array[teCombatTargetRequirementBase]


func fits(
	state: teCombatState,
	unit_id: int,
	target: teCombatTargetBase
) -> bool:
	for requirement in requirements:
		if not requirement.fits(target, state, unit_id):
			return false
	return true
