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
		expanded.append(teCombatActions.initiative_advance())
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
				expanded.append(teCombatActions.initiative_advance())
				return expanded
		if unit.get_attack_pattern() != null:
			unit.attack_pattern.expand(command.unit_id, command.target_id, runtime, state, expanded)
		else:
			expanded.append(teCombatActions.unit_attack(command.unit_id, command.target_id))
		expanded.append(teCombatActions.initiative_advance())
	if command is teCombatCommandUnitCastSkill:
		expanded.append(teCombatActions.unit_cast(command.unit_id, command.target))
		var unit := state.unit(command.unit_id)
		if unit.skill.ends_turn:
			expanded.append(teCombatActions.initiative_advance())
	return expanded


func resolve(
	state: teCombatState,
	runtime: teCombatRuntime,
	action: teCombatActionBase,
	context: Context
) -> teCombatResolvedAction:
	var resolved := teCombatResolvedAction.new(action, context)
	if action is teCombatActionUnitCastSkill:
		var unit := state.unit(action.unit_id)
		var mana_spent := unit.stats.required_mana
		resolved.emit(teCombatEvents.mana_spent(action.unit_id, mana_spent))
		unit.skill.resolve(action.target, state, runtime, resolved)
	if action is teCombatActionInitiativeAdvance:
		var next_unit_id := teCombatInitiative.calc_next_unit_id(state)
		var progress_made := teCombatInitiative.progress_left(state.unit(next_unit_id))
		resolved.emit(teCombatEvents.initiative_progressed(progress_made))
		resolved.emit(teCombatEvents.initiative_taken(next_unit_id))
		teCombatEffects.apply_on_hook(teCombatEffects.Hook.TURN_START, next_unit_id, runtime, state, resolved)
		teCombatEffects.consume_with_duration(teCombatEffects.Duration.TURNS, next_unit_id, runtime, state, resolved)
	if action is teCombatActionUnitAttack:
		if not state.has_unit(action.target_id):
			return teCombatResolvedAction.unresolved()
		var attacker := state.unit(action.unit_id)
		
		if teCombatDodge.check(action.unit_id, action.target_id, runtime, state):
			resolved.schedule(teCombatActions.dodge_attack(action.target_id))
			return
		
		teCombatEffects.apply_on_hook(teCombatEffects.Hook.ATTACK, action.unit_id, runtime, state, resolved)
		teCombatEffects.consume_with_duration(teCombatEffects.Duration.ATTACKS, action.unit_id, runtime, state, resolved)
		
		resolved.schedule(teCombatActions.damage(
			action.target_id, teCombatDamage.TYPE.PHYSICAL, attacker.stats.attack_damage
		))
		
		resolved.emit(teCombatEvents.mana_gained(
			action.unit_id,
			7 # TODO: Implement properly
		))
	if action is teCombatActionUnitMove:
		resolved.emit(teCombatEvents.unit_moved(
			action.unit_id, action.path.through
		))
	if action is teCombatActionDamage:
		for instance in action.instances:
			resolved.emit(teCombatEvents.unit_damaged(instance))
			if teCombatDamage.is_lethal(state, instance):
				resolved.emit(teCombatEvents.unit_died(instance.target_unit_id))
				if state.active_unit_id() == instance.target_unit_id:
					resolved.schedule(teCombatActions.initiative_advance())
	if action is teCombatActionApplyEffect:
		for unit_id in action.units:
			var inst := teCombatEffects.instance(action.effect, action.charges, action.duration)
			var effect_id := runtime.effect_id()
			resolved.emit(teCombatEvents.effect_applied(unit_id, effect_id, inst))
	return resolved


func is_valid(state: teGameState) -> bool:
	return true
