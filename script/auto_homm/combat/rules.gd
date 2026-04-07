class_name teCombatRules extends Resource


func is_finished(runtime: teCombatRuntime) -> bool:
	var alive_teams: Dictionary[int, bool] = {}
	for unit_id in runtime.state.all_units_id():
		var unit := runtime.state.unit(unit_id)
		if unit.is_alive():
			var team_id := runtime.state.unit_team_id(unit_id)
			alive_teams[team_id] = true
	return alive_teams.size() <= 1


func is_hero_turn(runtime: teCombatRuntime) -> bool:
	return false


func progress(runtime: teCombatRuntime):
	var state := runtime.state
	if state.turn_in_progress():
		return
	var next_unit_id := teCombatInitiative.calc_next_unit_id(state)
	var progress_made := teCombatInitiative.progress_left(state.unit(next_unit_id))
	runtime.update(teCombatEvents.initiative_progressed(progress_made))
	runtime.update(teCombatEvents.initiative_taken(next_unit_id))


func auto_command(runtime: teCombatRuntime) -> teCombatCommandBase:
	var state := runtime.state
	var active_unit := state.active_unit()
	var target_id := teCombatTargeting.find(state.initiative_holder_id, state)
	var target := runtime.state.unit(target_id)
	if HexMath.distance(target.hex, active_unit.hex) > active_unit.stats.attack_range:
		var path := teCombatPathfinding.path_to_attack(runtime, active_unit, target)
		var movement_path = path.slice(0, active_unit.stats.movement_range + 1)
		movement_path.push_front(active_unit.hex)
		return teCombatCommands.unit_move(
			state.initiative_holder_id, 
			movement_path
		)
	return teCombatCommands.unit_attack(state.initiative_holder_id, target_id)


func process(runtime: teCombatRuntime, command: teCombatCommandBase):
	var state := runtime.state
	if is_first_turn_command(runtime, command):
		runtime.update(teCombatEvents.turn_started())
	if command is teCombatCommandStart:
		pass
	if command is teCombatCommandUnitMove:
		runtime.update(teCombatEvents.unit_moved(command.unit_id, command.move_path))
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
	if ends_turn(runtime, command):
		runtime.update(teCombatEvents.turn_finished())


func is_first_turn_command(runtime: teCombatRuntime, command: teCombatCommandBase) -> bool:
	return not (command is teCombatCommandUnitMove and runtime.state.active_unit_moved)


func ends_turn(runtime: teCombatRuntime, command: teCombatCommandBase) -> bool:
	return not (command is teCombatCommandUnitMove)


func is_valid(runtime: teCombatRuntime) -> bool:
	return true
	
