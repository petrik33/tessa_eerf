class_name teCombatRules extends Resource


func prepare(runtime: teCombatRuntime):
	runtime.begin_turn()
	runtime.apply(teCombatInitiative.progress(runtime.state))
	runtime.end_turn()


func is_finished(runtime: teCombatRuntime) -> bool:
	var alive_teams: Dictionary[int, bool] = {}
	for unit_id in runtime.state.all_units_id():
		var unit := runtime.state.unit(unit_id)
		if unit.is_alive():
			var team_id := runtime.state.unit_team_id(unit_id)
			alive_teams[team_id] = true
	return alive_teams.size() <= 1


func progress(runtime: teCombatRuntime) -> teCombatCommandBase:
	var target_id := teCombatTargeting.find(runtime.state.initiative_holder_id, runtime.state)
	return teCombatCommands.unit_attack(runtime.state.initiative_holder_id, target_id)


func process(runtime: teCombatRuntime, command: teCombatCommandBase):
	runtime.update(teCombatEvents.turn_started())
	var state := runtime.state
	if command is teCombatCommandStart:
		pass
	if command is teCombatCommandUnitAttack:
		var target := state.unit(command.target_id)
		var attacker := state.unit(command.unit_id)
		var damage := teCombatDamage.calculate(state, attacker, target)
		runtime.update(teCombatEvents.unit_attacked(
			command.target_id,
			command.unit_id,
			damage,
			teCombatDamage.is_lethal(state, target, damage)
		))
	runtime.update(teCombatInitiative.progress(state))
	runtime.update(teCombatEvents.turn_finished())


func is_valid(runtime: teCombatRuntime) -> bool:
	return true
	
