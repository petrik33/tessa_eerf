class_name teCombatRules extends Resource


func prepare(
	state: teCombatState,
	services: teCombatServices
) -> teCombatEventLog:
	var event_log := teCombatEventLog.new()
	event_log.events.append(teCombatInitiative.progress(state))
	return event_log


func is_finished(state: teCombatState) -> bool:
	var alive_teams: Dictionary[int, bool] = {}
	for unit_id in state.all_units_id():
		var unit := state.unit(unit_id)
		if unit.is_alive():
			var team_id := state.unit_team_id(unit_id)
			alive_teams[team_id] = true
	return alive_teams.size() <= 1


func progress(
	state: teCombatState,
	services: teCombatServices
) -> teCombatCommandBase:
	var target_id := teCombatTargeting.find(state.initiative_holder_id, state)
	return teCombatCommands.unit_attack(state.initiative_holder_id, target_id)


func process(
	combat: teCombatState,
	command: teCombatCommandBase,
	services: teCombatServices
) -> teCombatEventLog:
	var event_log := teCombatEventLog.new()
	fill_log(combat, command, services, event_log.events)
	return event_log


func fill_log(
	state: teCombatState,
	command: teCombatCommandBase,
	services: teCombatServices,
	events: Array[teCombatEventBase]
):
	events.push_back(teCombatEvents.turn_started())
	if command is teCombatCommandUnitAttack:
		var target := state.unit(command.target_id)
		var attacker := state.unit(command.unit_id)
		var damage := teCombatDamage.calculate(state, attacker, target)
		events.push_back(teCombatEvents.unit_attacked(
			command.target_id,
			command.unit_id,
			damage,
			teCombatDamage.is_lethal(state, target, damage)
		))
	events.push_back(teCombatInitiative.progress(state))
	events.push_back(teCombatEvents.turn_finished())


func is_valid(state: teCombatState, services: teCombatServices) -> bool:
	return true
	
