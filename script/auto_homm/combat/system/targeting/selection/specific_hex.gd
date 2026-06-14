class_name teCombatTargetSelectionSpecificHex extends teCombatTargetSelectionBase


@export var specification: teCombatTargetHexSpecification = teCombatTargetHexSpecification.new()
@export var query: teCombatTargetHexQueryBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	for target in query.iter(state, context):
		if specification.fits(target.hex, state, context):
			return target
	return teCombatTargets.invalid()
