class_name CombatState extends Resource


@export var armies: Array[CombatArmy] = []
@export var turn_queue: Array[CombatUnitHandle] = []


func get_current_unit() -> CombatUnit:
	return get_unit(get_current_unit_handle())


func get_current_army() -> CombatArmy:
	return get_army(get_current_army_handle())


func get_current_unit_handle() -> CombatUnitHandle:
	return turn_queue.front()


func get_current_army_handle() -> CombatArmyHandle:
	return CombatArmyHandle.new(get_current_unit_handle().army_idx)


func get_unit(unit_handle: CombatUnitHandle) -> CombatUnit:
	return armies[unit_handle.army_idx].units[unit_handle.idx]


func get_army(army_handle: CombatArmyHandle) -> CombatArmy:
	return armies[army_handle.idx]


func get_all_unit_handles() -> Array[CombatUnitHandle]:
	var unit_handles: Array[CombatUnitHandle] = []
	var army_idx := 0
	var unit_idx := 0
	for army in armies:
		for unit in army.units:
			unit_handles.push_back(CombatUnitHandle.new(unit_idx, army_idx))
			unit_idx += 1
		army_idx += 1
	return unit_handles


func apply_actions(buffer: CombatActionsBuffer):
	for action in buffer.actions:
		apply_action(action)


func apply_action(action: CombatActionBase):
	if action is CombatActionPopTurnQueue:
		turn_queue.pop_front()
		return
	if action is CombatActionMove:
		get_unit(action.unit_handle).placement = action.target_hex()
		return
	if action is CombatActionAppendToTurnQueue:
		append_to_turn_queue(action.unit_handle)
		return


func append_to_turn_queue(unit_handle: CombatUnitHandle):
	turn_queue.append(unit_handle)
