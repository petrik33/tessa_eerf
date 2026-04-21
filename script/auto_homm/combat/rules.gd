class_name teCombatRules extends Resource


func is_finished(state: teCombatState) -> bool:
	var alive_teams: Dictionary[int, bool] = {}
	for unit_id in state.all_units_id():
		var unit := state.unit(unit_id)
		if unit.is_alive():
			var team_id := state.unit_team_id(unit_id)
			alive_teams[team_id] = true
	return alive_teams.size() <= 1


func is_hero_turn(_state: teCombatState) -> bool:
	return false


#func progress(runtime: teCombatRuntime):
	#var state := runtime.state
	#if state.turn_in_progress():
		#return
	#var next_unit_id := teCombatInitiative.calc_next_unit_id(state)
	#var progress_made := teCombatInitiative.progress_left(state.unit(next_unit_id))
	#runtime.update(teCombatEvents.initiative_progressed(progress_made))
	#runtime.update(teCombatEvents.initiative_taken(next_unit_id))


func auto_command(state: teCombatState) -> teCombatCommandBase:
	var target_id := teCombatTargeting.find(state.initiative_holder_id, state)
	if target_id == -1:
		return teCombatCommands.unit_wait(state.initiative_holder_id)
	return teCombatCommands.unit_attack(state.initiative_holder_id, target_id)


func expand(
	runtime: teCombatRuntime,
	state: teCombatState,
	command: teCombatCommandBase
) -> teCombatExpandedCommand:
	var expanded := teCombatExpandedCommand.new(command)
	if command is teCombatCommandStart:
		expanded.append(teCombatActions.initiative_advance())
	if command is teCombatCommandUnitWait:
		# TODO: Reduce initiative
		pass
	if command is teCombatCommandUnitAttack:
		var unit := state.unit(command.unit_id)
		var target := state.unit(command.target_id)
		if HexMath.distance(target.hex, unit.hex) > unit.stats.attack_range:
			var path := teCombatPathfinding.path_to_attack(runtime, unit, target)
			var movement_path = teCombatMovementPath.new(
				unit.hex,
				path.slice(0, unit.stats.movement_range + 1)
			)
			expanded.append(teCombatActions.unit_move(command.unit_id, movement_path))
			if HexMath.distance(target.hex, movement_path.destination()) > unit.stats.attack_range:
				return expanded
		expanded.append(teCombatActions.unit_attack(command.unit_id, command.target_id))
	return expanded


func interrupt(
	runtime: teCombatRuntime,
	state: teCombatState,
	action: teCombatActionBase
):
	pass


func resolve(
	state: teCombatState,
	action: teCombatActionBase
) -> teCombatResolvedAction:
	var resolved := teCombatResolvedAction.new(action)
	if action is teCombatActionInitiativeAdvance:
		var next_unit_id := teCombatInitiative.calc_next_unit_id(state)
		var progress_made := teCombatInitiative.progress_left(state.unit(next_unit_id))
		resolved.push_back(teCombatEvents.initiative_progressed(progress_made))
		resolved.push_back(teCombatEvents.initiative_taken(next_unit_id))
	if action is teCombatActionUnitAttack:
		var target := state.unit(action.target_id)
		var attacker := state.unit(action.unit_id)
		var damage := teCombatDamage.calculate(state, attacker, target)
		resolved.push_back(teCombatEvents.unit_damaged(
			action.target_id,
			damage
		))
		if teCombatDamage.is_lethal(state, target, damage):
			resolved.push_back(teCombatEvents.unit_died(action.target_id))
		resolved.push_back(teCombatEvents.mana_gained(
			action.unit_id,
			7 # TODO: Implement properly
		))
	if action is teCombatActionUnitMove:
		resolved.push_back(teCombatEvents.unit_moved(
			action.unit_id, action.path.through
		))
	return resolved


func react(
	runtime: teCombatRuntime,
	state: teCombatState,
	action: teCombatResolvedAction
):
	pass


func is_valid(runtime: teCombatRuntime) -> bool:
	return true
	
