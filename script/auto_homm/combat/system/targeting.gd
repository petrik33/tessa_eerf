class_name teCombatTargeting


func _init() -> void:
	Utils.assert_static_lib()


enum Mode {
	UNIT,
	UNIT_OR_UNITS,
	AREA,
	LOCATION,
	SELF_AOE,
	SELF,
	CONE,
	DIRECTION,
	UNIT_AND_LOCATION,
	INVALID,
}


static func auto(
	state: teCombatState,
	unit_id: int,
	profile: teCombatTargetingProfile
) -> teCombatTargetBase:
	if profile.priority != null:
		if profile.specification != null:
			return specific_prioritized(
				state,
				unit_id,
				profile.query,
				profile.specification,
				profile.priority
			)
		else:
			return prioritized(
				state,
				unit_id,
				profile.query,
				profile.priority
			)
	else:
		if profile.specification != null:
			return first_specific(
				state,
				unit_id,
				profile.query,
				profile.specification
			)
		else:
			return first_in_query(state, unit_id, profile.query)


static func all_valid(
	state: teCombatState,
	unit_id: int,
	query: teCombatTargetQueryBase,
	specification: teCombatTargetSpecification = null
) -> Array[teCombatTargetBase]:
	var all_targets := query.collect(state, unit_id)
	if specification == null:
		return all_targets
	var fits := func (target): return specification.fits(state, unit_id, target)
	return all_targets.filter(fits)


static func first_in_query(
	state: teCombatState,
	unit_id: int,
	query: teCombatTargetQueryBase
) -> teCombatTargetBase:
	return Utils.iter_first(query.iter(state, unit_id))


static func specific_prioritized(
	state: teCombatState,
	unit_id: int,
	query: teCombatTargetQueryBase,
	specification: teCombatTargetSpecification,
	priority: teCombatTargetPriorityBase
) -> teCombatTargetBase:
	var all_targets := query.collect(state, unit_id)
	var is_prior := func (targetA, targetB): 
		return priority.is_prior(state, unit_id, targetA, targetB)
	all_targets.sort_custom(is_prior)
	var fits := func(target): 
		return specification.fits(state, unit_id, target)
	var idx := all_targets.find_custom(fits)
	if idx == -1:
		return teCombatTargets.invalid()
	return all_targets[idx]


static func first_specific(
	state: teCombatState,
	unit_id: int,
	query: teCombatTargetQueryBase,
	specification: teCombatTargetSpecification,
) -> teCombatTargetBase:
	for target in query.iter(state, unit_id):
		if specification.fits(state, unit_id, target):
			return target
	return teCombatTargets.invalid()


static func prioritized(
	state: teCombatState,
	unit_id: int,
	query: teCombatTargetQueryBase,
	priority: teCombatTargetPriorityBase
) -> teCombatTargetBase:
	return Utils.iter_prioritized(
		query.iter(state, unit_id),
		func (a, b): return priority.is_prior(state, unit_id, a, b)
	)


static func is_valid(target: teCombatTargetBase) -> bool:
	return not target is teCombatTargetInvalid


static func target_fits_mode(target: teCombatTargetBase, mode: Mode) -> bool:
	match mode:
		Mode.UNIT:
			return target is teCombatTargetUnit and target.is_single()
		Mode.LOCATION:
			return target is teCombatTargetHex
		Mode.UNIT_AND_LOCATION:
			return target is teCombatTargetUnitAndHex
		Mode.UNIT_OR_UNITS:
			return target is teCombatTargetUnit
		Mode.SELF:
			return target is teCombatTargetUnit
	return false
