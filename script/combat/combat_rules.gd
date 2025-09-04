class_name CombatRules extends Resource

# TODO: Extract interface to base class
# TODO: Extract some implementations as static in utility class


func process_command(command: CombatCommandBase, state: CombatState, runtime: CombatRuntime) -> CombatActionsBuffer:
	var buffer = CombatActionsBuffer.new()
	fill_actions_buffer(command, state, runtime, buffer)
	return buffer


func fill_actions_buffer(command: CombatCommandBase, state: CombatState, runtime: CombatRuntime, buffer: CombatActionsBuffer) -> void:
	if command is CombatCommandStartCombat:
		for unit_handle in state.get_all_unit_handles():
			buffer.push_back(CombatActionAppendToTurnQueue.new(unit_handle))
	if command is CombatCommandMoveUnit:
		buffer.push_back(CombatActions.move(state, runtime, command.id_path))
		buffer.push_back(CombatActionPopTurnQueue.new())
		buffer.push_back(CombatActionAppendToTurnQueue.new(state.get_current_unit_handle()))
		return
	if command is CombatCommandAttackUnit:
		buffer.push_back(CombatActions.move(state, runtime, command.move_id_path))
		buffer.push_back(CombatActionPopTurnQueue.new())
		buffer.push_back(CombatActionAppendToTurnQueue.new(state.get_current_unit_handle()))
		return


func validate_command(command: CombatCommandBase, _state: CombatState, _runtime: CombatRuntime) -> bool:
	# TODO: Actual implementation
	return command != null


func is_combat_finished(_state: CombatState) -> bool:
	# TODO: Actual implementation
	return false
