class_name CombatRules extends Resource

# TODO: Extract interface to base class
# TODO: Extract some implementations as static in utility class

func fill_initial_state(state: CombatState) -> void:
	for unit_handle in state.all_unit_handles():
		state.append_to_turn_queue(unit_handle)


func process_command(command: CombatCommandBase, state: CombatState, services: CombatServices) -> CombatActionsBuffer:
	var buffer = CombatActionsBuffer.new()
	fill_actions_buffer(command, state, services, buffer)
	return buffer


func fill_actions_buffer(command: CombatCommandBase, state: CombatState, services: CombatServices, buffer: CombatActionsBuffer) -> void:
	if command is CombatCommandMoveUnit:
		buffer.push_back(CombatActions.move(state, services, command.id_path))
		_update_turn_queue_position(state, buffer)
		return
	if command is CombatCommandMeleeAttackUnit:
		buffer.push_back(CombatActions.move(state, services, command.move_id_path))
		_update_turn_queue_position(state, buffer)
		var attacking_unit_handle := state.current_unit_handle()
		var attacking_unit := state.unit(attacking_unit_handle)
		var attacked_unit_handle := state.find_unit_handle_by_hex(command.attacked_hex)
		var attacking_hex_id = command.move_id_path[command.move_id_path.size() - 1]
		var attacking_hex := services.navigation.hex(attacking_hex_id)
		# TODO: Proper damage calculation
		var damage := calculate_melee_damage(attacking_unit, state.unit(attacked_unit_handle))
		buffer.push_back(CombatActions.melee_attack(
			attacking_unit_handle,
			attacked_unit_handle,
			attacking_hex,
			damage
		))
		return
	if command is CombatCommandRangedAttackUnit:
		_update_turn_queue_position(state, buffer)
		var attacking_unit_handle := state.find_unit_handle_by_hex(command.from)
		var target_unit_handle := state.find_unit_handle_by_hex(command.to)
		var damage := calculate_ranged_damage(
			state.unit(attacking_unit_handle),
			state.unit(target_unit_handle)
		)
		buffer.push_back(CombatActions.ranged_attack(
			attacking_unit_handle,
			target_unit_handle,
			damage
		))
		return
	if command is CombatCommandUnitWait:
		# TODO: Implement initiative queue or rounds
		_update_turn_queue_position(state, buffer)
		return
	if command is CombatCommandUnitDefend:
		# TODO: Implement defence increase
		_update_turn_queue_position(state, buffer)
		return
	


func validate_command(command: CombatCommandBase, _state: CombatState, _services: CombatServices) -> bool:
	# TODO: Actual implementation
	return command != null


func is_combat_finished(_state: CombatState) -> bool:
	# TODO: Actual implementation
	return false


func _update_turn_queue_position(state: CombatState, buffer: CombatActionsBuffer):
	buffer.push_back(CombatActionPopTurnQueue.new())
	buffer.push_back(CombatActionAppendToTurnQueue.new(state.current_unit_handle()))


func calculate_melee_damage(attacking: CombatUnit, defending: CombatUnit) -> int:
	return attacking.stats().damage_range.y


func calculate_ranged_damage(attacking: CombatUnit, defending: CombatUnit) -> int:
	return attacking.stats().damage_range.y
