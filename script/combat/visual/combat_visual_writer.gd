class_name CombatVisualWriter extends Resource

@export var hex_layout: HexLayout

func intro(runtime: CombatRuntime) -> CombatVisualActionsQueue:
	var queue := CombatVisualActionsQueue.new()
	var idx := 0
	for unit in runtime.state().units:
		queue.push_back(CombatVisualActions.idle(
			idx,
			hex_layout.hex_to_pixel(unit.placement),
			_get_unit_enemy_direction(unit)
		))
		idx += 1
	return queue

func sequence(runtime: CombatRuntime, command: CombatCommandBase, buffer: CombatActionsBuffer) -> CombatVisualActionsQueue:
	var queue := CombatVisualActionsQueue.new()
	
	for action in buffer.actions:
		if action is CombatActionMove:
			var path = Utils.to_typed(TYPE_VECTOR2, action.path.map(
				func(hex: Vector2i): return hex_layout.hex_to_pixel(hex)
			))
			queue.push_back(CombatVisualActions.walk(action.unit_idx, path))
			queue.push_back(CombatVisualActions.idle(
				action.unit_idx,
				hex_layout.hex_to_pixel(action.path[-1]),
				_get_unit_enemy_direction(runtime.state().units[action.unit_idx])
			))
			continue
	return queue

func _get_unit_enemy_direction(unit: CombatUnitState) -> float:
	return 0 if unit.side_idx == 0 else PI
