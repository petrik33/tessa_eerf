class_name teCombatTargetSelectionSpecificUnit extends teCombatTargetSelectionBase


@export var specification: teCombatTargetUnitSpecification = teCombatTargetUnitSpecification.new()
@export var query: teCombatTargetUnitQueryBase


func first_target(state: teCombatState, runtime: teCombatRuntime, context: Context) -> teCombatTargetBase:
	for target in query.iter(state, context):
		var unit := state.unit(target.unit_id)
		if specification.fits(unit, target.unit_id, state, context):
			return target
	return teCombatTargets.invalid()
