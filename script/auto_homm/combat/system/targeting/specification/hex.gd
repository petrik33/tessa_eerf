class_name teCombatTargetHexSpecification extends Resource


@export var requirements: Array[teCombatTargetHexRequirementBase]


func fits(
	hex: Vector2i,
	state: teCombatState,
	context: Context
) -> bool:
	for requirement in requirements:
		if not requirement.hex_fits(hex, state, context):
			return false
	return true
