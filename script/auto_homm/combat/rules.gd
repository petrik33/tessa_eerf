class_name teCombatRules extends Resource


func initialize(setup: teCombatSetup, unit_set: teUnitSet, unit_roster: teCombatUnitRoster) -> teCombatState:
	var state := teCombatState.new()
	var team_id := 0
	for team in setup.teams:
		for unit_id in team.units_placement:
			var unit := unit_roster.get_unit(unit_id)
			var unit_initial_state := teCombatUnitState.new()
			var unit_definition := unit_set.get_definition(unit.definition_uid)
			unit_initial_state.hex = team.units_placement[unit_id]
			unit_initial_state.hp = unit_definition.stats.max_hp
			unit_initial_state.mana = 0
			state.units[unit_id] = unit_initial_state
			state.unit_teams[unit_id] = team_id
		team_id += 1
	for unit_id in state.units:
		state.turn_queue.push_back(unit_id)
	return state


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
	if command is teCombatCommandUnitMeleeAttack:
		events.push_back(teCombatEvents.unit_melee_hit(
			command.target_id,
			command.unit_id,
			10,
			false
		))
	events.push_back(teCombatEvents.progress_turn())
	
