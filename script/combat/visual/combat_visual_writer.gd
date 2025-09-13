class_name CombatVisualWriter extends Resource


@export var hex_layout: HexLayout


func intro(state: CombatState) -> CombatVisualActionsQueue:
	var queue := CombatVisualActionsQueue.new()
	for unit_handle in state.all_unit_handles():
		var unit := state.unit(unit_handle)
		queue.push_back(CombatVisualActions.idle(
			unit_handle,
			hex_layout.hex_to_pixel(unit.placement),
			_get_unit_enemy_direction(unit)
		))
	return queue


func sequence(state: CombatState, _command: CombatCommandBase, buffer: CombatActionsBuffer) -> CombatVisualActionsQueue:
	var queue := CombatVisualActionsQueue.new()

	for action in buffer.actions:
		if action is CombatActionMove:
			var path = Utils.to_typed(TYPE_VECTOR2, action.path.map(
				func(hex: Vector2i): return hex_layout.hex_to_pixel(hex)
			))
			queue.push_back(CombatVisualActions.walk(action.unit_handle, path))
			queue.push_back(CombatVisualActions.idle(
				action.unit_handle,
				hex_layout.hex_to_pixel(action.path[-1]),
				_get_unit_enemy_direction(state.unit(action.unit_handle))
			))
			continue
		if action is CombatActionMeleeAttack:
			queue.push_back(CombatVisualActions.melee(action.attacking, hex_layout.hex_to_pixel(action.from_hex)))
			queue.push_back(CombatVisualActions.idle(
				action.attacking,
				hex_layout.hex_to_pixel(action.from_hex),
				_get_unit_enemy_direction(state.unit(action.attacking))
			))
			queue.push_back(CombatVisualActions.hurt(action.defending))
			queue.push_back(CombatVisualActions.idle(
				action.defending,
				hex_layout.hex_to_pixel(state.unit(action.defending).placement),
				_get_unit_enemy_direction(state.unit(action.defending))
			))
	return queue


func _get_unit_enemy_direction(unit: CombatUnit) -> float:
	# TODO: Solve properly
	return 0.0 if unit.placement.x < 5 else PI
