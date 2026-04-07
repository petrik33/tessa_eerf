class_name teCombatInitiative


func _init() -> void:
	Utils.assert_static_lib()


static func calc_next_unit_id(combat: teCombatState) -> int:
	var next_unit_id := -1
	var smallest_progress_left := INF
	var potential_unit_progress := 0.0
	for unit_id in combat.all_units_id():
		var unit := combat.unit(unit_id)
		var unit_progress_left := progress_left(unit)
		var tie := is_equal_approx(unit_progress_left, smallest_progress_left)
		if tie and unit.initiative_progress > potential_unit_progress \
				or unit_progress_left < smallest_progress_left:
			next_unit_id = unit_id
			smallest_progress_left = unit_progress_left
			potential_unit_progress = unit.initiative_progress
	return next_unit_id


static func progress_left(unit: teCombatUnitState) -> float:
	return 1.0 / unit.stats.initiative - unit.initiative_progress
