class_name CombatRules extends Resource

# TODO: Extract interface to base class
# TODO: Extract some implementations as static in utility class

# TODO: Ensure valid config
func get_initial_state(config: CombatConfig) -> CombatState:
	var state = CombatState.new()
	for unit in config.units:
		var unit_state = CombatUnitState.new(unit.data, unit.placement, unit.combat_side)
		state.units.append(unit_state)
	var idx = 0
	for unit in state.units:
		state.turn_queue.append(idx)
		idx += 1
	return state

func get_current_combat_side_idx(state: CombatState) -> int:
	return state.current_unit().side_idx

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
	return true
	
func is_combat_finished(state: CombatState) -> bool:
	# TODO: Actual implementation
	return false
