class_name teCombatRules extends Resource


func prepare(
	combat: teCombatState,
	services: teCombatServices
) -> teCombatEventLog:
	var event_log := teCombatEventLog.new()
	return event_log


func is_finished(combat: teCombatState) -> bool:
	var alive_teams: Dictionary[int, bool] = {}
	for unit_id in combat.all_units_id():
		var unit := combat.unit(unit_id)
		if unit.is_alive():
			var team_id := combat.unit_team_id(unit_id)
			alive_teams[team_id] = true
	return alive_teams.size() <= 1
		


func progress(
	combat: teCombatState,
	services: teCombatServices
) -> teCombatCommandBase:
	var current_unit_id := combat.current_unit_id()
	var target_id := teCombatTargeting.find(current_unit_id, combat)
	return teCombatCommands.melee(current_unit_id, target_id)


func process(
	combat: teCombatState,
	command: teCombatCommandBase,
	services: teCombatServices
) -> teCombatEventLog:
	var event_log := teCombatEventLog.new()
	fill_log(combat, command, services, event_log.events)
	return event_log


func fill_log(
	combat: teCombatState,
	command: teCombatCommandBase,
	services: teCombatServices,
	events: Array[teCombatEventBase]
):
	events.push_back(teCombatEvents.turn_started())
	if command is teCombatCommandUnitMeleeAttack:
		events.push_back(teCombatEvents.unit_melee_hit(
			command.target_id,
			command.unit_id,
			10,
			false
		))
	events.push_back(teCombatEvents.turn_finished())


func is_valid(combat: teCombatState) -> bool:
	return true
	
