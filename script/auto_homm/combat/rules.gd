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


func auto_command(runtime: teCombatRuntime, state: teCombatState) -> teCombatCommandBase:
	var active_unit_id := state.active_unit_id()
	var active_unit := state.active_unit()
	if active_unit.can_cast():
		var target := active_unit.skill.find_target(active_unit_id, state, runtime)
		if teCombatTargeting.is_valid(target):
			return teCombatCommands.unit_cast_skill(active_unit_id, target)
	var target_id := teCombatTargeting.unit_attack(active_unit_id, state)
	if target_id == -1:
		return teCombatCommands.unit_wait(active_unit_id)
	return teCombatCommands.unit_attack(active_unit_id, target_id)


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
		if not unit.in_attack_range(target):
			var movement_path = teCombatPathfinding.path_to_attack(runtime, unit, target)
			if not movement_path.is_valid():
				return teCombatExpandedCommand.invalid()
			expanded.append(teCombatActions.unit_move(command.unit_id, movement_path))
			if movement_path.length() > unit.stats.movement_range:
				movement_path.limit(unit.stats.movement_range)
				return expanded
		expanded.append(teCombatActions.unit_attack(command.unit_id, command.target_id))
	if command is teCombatCommandUnitCastSkill:
		expanded.append(teCombatActions.unit_cast(command.unit_id))
		var unit := state.unit(command.unit_id)
		unit.skill.expand(command.unit_id, command.target, state, runtime, expanded)
	return expanded


func interrupt(
	runtime: teCombatRuntime,
	state: teCombatState,
	action: teCombatActionBase
):
	pass


func resolve(
	state: teCombatState,
	action: teCombatActionBase,
	context: Context
) -> teCombatResolvedAction:
	var resolved := teCombatResolvedAction.new(action, context)
	if action is teCombatActionUnitCastSkill:
		var unit := state.unit(action.unit_id)
		var mana_spent := unit.stats.required_mana
		resolved.push_back(teCombatEvents.mana_spent(action.unit_id, mana_spent))
	if action is teCombatActionInitiativeAdvance:
		var next_unit_id := teCombatInitiative.calc_next_unit_id(state)
		var progress_made := teCombatInitiative.progress_left(state.unit(next_unit_id))
		resolved.push_back(teCombatEvents.initiative_progressed(progress_made))
		resolved.push_back(teCombatEvents.initiative_taken(next_unit_id))
	if action is teCombatActionUnitAttack:
		if not state.has_unit(action.target_id):
			return teCombatResolvedAction.unresolved()
		var target := state.unit(action.target_id)
		var attacker := state.unit(action.unit_id)
		var damage := teCombatDamage.calculate(state, attacker, target)
		resolved.push_back(teCombatEvents.unit_damaged(
			action.target_id,
			damage
		))
		if resolved.context.read_or(teCombatContext.ADD_MANA, true):
			resolved.push_back(teCombatEvents.mana_gained(
				action.unit_id,
				7 # TODO: Implement properly
			))
		if teCombatDamage.is_lethal(state, target, damage):
			resolved.push_back(teCombatEvents.unit_died(action.target_id))
	if action is teCombatActionUnitMove:
		resolved.push_back(teCombatEvents.unit_moved(
			action.unit_id, action.path.through
		))
	return resolved


func resolve_damage(
	state: teCombatState,
	action: teCombatActionBase,
	context: Context,
	resolved: teCombatResolvedAction,
	instance: teCombatDamageInstance
):
	pass


func react(
	runtime: teCombatRuntime,
	state: teCombatState,
	action: teCombatResolvedAction
):
	pass


#func cast(state: teCombatState, unit_id: int, expanded: teCombatExpandedCommand):
	#var unit := state.unit(unit_id)
	#var skill := unit.skill
	#if skill is teCombatSkillUnitComboAttack:
		#var target := teCombatTargeting.find(unit_id, state, skill.targeting)
		#if target == -1:
			#expanded.invalidate()
			#return
		#for idx in range(skill.attacks_number):
			#var context := teCombatActionContext.new()
			#context.add(teCombatActionsContext.COMBO_HIT, idx + 1)
			#expanded.append(teCombatActions.unit_attack(unit_id, target), context)
	


func is_valid(runtime: teCombatRuntime) -> bool:
	return true
	
