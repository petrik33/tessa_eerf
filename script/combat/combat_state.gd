class_name CombatState extends Resource

@export var units: Array[CombatUnitState] = []
@export var turn_queue: Array[int] = []

func current_unit() -> CombatUnitState:
	return units[current_unit_idx()]

func current_unit_idx() -> int:
	return turn_queue.front()

func current_placement() -> Vector2i:
	return current_unit().placement

func unit_on_hex(hex: Vector2i) -> CombatUnitState:
	for unit in units:
		if unit.placement == hex:
			return unit
	return null

func enemies(side_idx: int) -> Array[CombatUnitState]:
	return units.filter(
		func(unit: CombatUnitState): return unit.is_an_enemy(side_idx)
	)

func enemies_placement(side_idx: int) -> Array[Vector2i]:
	return enemies(side_idx).map(
		func(unit): return unit.placement
	)

func allies(side_idx: int) -> Array[CombatUnitState]:
	return units.filter(
		func(unit: CombatUnitState): return unit.is_an_ally(side_idx)
	)

func apply_actions(buffer: CombatActionsBuffer):
	for action in buffer.actions:
		apply_action(action)
		
func apply_action(action: CombatActionBase):
	if action is CombatActionPopTurnQueue:
		turn_queue.pop_front()
		return
	if action is CombatActionMove:
		units[action.unit_idx].placement = action.target_hex()
		return
	if action is CombatActionAppendToTurnQueue:
		turn_queue.append(action.unit_idx)
		return

func clone() -> CombatState:
	var cloned = CombatState.new()
	cloned.units = []
	cloned.units.resize(units.size())
	var unit_idx = 0
	for unit in units:
		cloned.units[unit_idx] = unit.duplicate(true)
		unit_idx += 1
	cloned.turn_queue = turn_queue.duplicate()
	return cloned
