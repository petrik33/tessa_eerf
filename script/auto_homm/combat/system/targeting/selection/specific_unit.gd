class_name teCombatTargetSelectionSpecificUnit extends teCombatTargetSelectionBase


@export var specification: teCombatTargetUnitSpecification = teCombatTargetUnitSpecification.new()
@export var query: teCombatTargetUnitQueryBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	for target in query.iter(state, context):
		var unit := state.unit(target.single())
		if specification.fits(unit, target.single(), state, context):
			return target
	return teCombatTargets.invalid()
