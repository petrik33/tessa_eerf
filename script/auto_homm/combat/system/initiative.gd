class_name teCombatInitiative


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func progress(combat: teCombatState) -> teCombatEventInitiativeTaken:
	var event := teCombatEventInitiativeTaken.new()
	var smallest_progress_left := INF
	var potential_unit_progress := 0.0
	for unit_id in combat.all_units_id():
		var unit := combat.unit(unit_id)
		var progress_left := 1.0 / unit.stats.initiative - unit.initiative_progress
		var tie := is_equal_approx(progress_left, smallest_progress_left)
		if tie and unit.initiative_progress > potential_unit_progress \
				or progress_left < smallest_progress_left:
			event.unit_id = unit_id
			smallest_progress_left = progress_left
			potential_unit_progress = unit.initiative_progress
	event.progress_made = smallest_progress_left
	return event
