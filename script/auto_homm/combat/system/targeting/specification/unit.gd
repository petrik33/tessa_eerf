class_name teCombatTargetUnitSpecification extends Resource


@export var requirements: Array[teCombatTargetUnitRequirementBase]


func fits(
	unit: teCombatUnitState,
	unit_id: int,
	state: teCombatState,
	context: Context
) -> bool:
	for requirement in requirements:
		if not requirement.unit_fits(unit, state, unit_id, context):
			return false
	return true
