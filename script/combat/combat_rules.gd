class_name CombatRules extends Resource

# TODO: Extract interface to base class
# TODO: Extract some implementations as static in utility class

# TODO: Ensure valid definition
func get_initial_state(definition: CombatDefinition) -> CombatState:
	var state := CombatState.new()
	var initializer := definition.initializer()
	var army_idx := -1
	var unit_idx := -1
	while not initializer.is_finished():
		if initializer.is_first_unit_in_army():
			var army := CombatArmy.new()
			army.units = []
			army_idx += 1
		state.armies[army_idx].units.append(initializer.get_current_unit())
		initializer.next()
	var unit_handles := state.get_all_unit_handles()
	for unit_handle in unit_handles:
		state.turn_queue.append(unit_handle)
	return state


func process_command(command: CombatCommandBase, runtime: CombatRuntime) -> CombatActionsBuffer:
	var buffer = CombatActionsBuffer.new()
	fill_actions_buffer(command, runtime, buffer)
	return buffer


func fill_actions_buffer(command: CombatCommandBase, runtime: CombatRuntime, buffer: CombatActionsBuffer) -> void:
	if command is CombatCommandMoveUnit:
		buffer.push_back(CombatActions.move(runtime, command.id_path))
		buffer.push_back(CombatActionPopTurnQueue.new())
		buffer.push_back(CombatActionAppendToTurnQueue.new(runtime.state().current_unit_idx()))
		return
	if command is CombatCommandAttackUnit:
		buffer.push_back(CombatActions.move(runtime, command.move_id_path))
		buffer.push_back(CombatActionPopTurnQueue.new())
		buffer.push_back(CombatActionAppendToTurnQueue.new(runtime.state().current_unit_idx()))
		return


func validate_command(command: CombatCommandBase, runtime: CombatRuntime) -> bool:
	# TODO: Actual implementation
	return command != null


func is_combat_finished(state: CombatState) -> bool:
	# TODO: Actual implementation
	return false
