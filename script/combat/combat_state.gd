class_name CombatState extends Resource


@export var armies: Array[CombatArmy] = []
@export var turn_queue: Array[CombatUnitHandle] = []


func current_unit() -> CombatUnit:
	return unit(current_unit_handle())


func current_army() -> CombatArmy:
	return army(current_army_handle())


func current_unit_handle() -> CombatUnitHandle:
	return turn_queue.front()


func current_army_handle() -> CombatArmyHandle:
	return CombatArmyHandle.new(current_unit_handle().army_idx)


func ally_units(army_handle: CombatArmyHandle) -> Array[CombatUnit]:
	return army(army_handle).units


func enemy_units(army_handle: CombatArmyHandle) -> Array[CombatUnit]:
	return all_units().filter(
		func (unit: CombatUnit): return unit.is_an_enemy(army_handle)
	)


func find_unit_handle_by_hex(hex: Vector2i) -> CombatUnitHandle:
	var unit_handles := all_unit_handles()
	var idx := unit_handles.find_custom(
		func (unit_handle: CombatUnitHandle): return unit(unit_handle).placement == hex
	)
	return null if idx == -1 else unit_handles[idx]


func all_units() -> Array[CombatUnit]:
	var unit_handles := all_unit_handles()
	var units: Array[CombatUnit] = []
	units.resize(unit_handles.size())
	var unit_idx := 0
	for unit_handle in unit_handles:
		units[unit_idx] = unit(unit_handle)
		unit_idx += 1
	return units


func all_unit_handles() -> Array[CombatUnitHandle]:
	var unit_handles: Array[CombatUnitHandle] = []
	var army_idx := 0
	for army in armies:
		var unit_idx := 0
		for unit in army.units:
			unit_handles.push_back(CombatUnitHandle.new(unit_idx, army_idx))
			unit_idx += 1
		army_idx += 1
	return unit_handles


func unit(unit_handle: CombatUnitHandle) -> CombatUnit:
	return armies[unit_handle.army_idx].units[unit_handle.idx]


func army(army_handle: CombatArmyHandle) -> CombatArmy:
	return armies[army_handle.idx]


func apply_actions(buffer: CombatActionsBuffer):
	for action in buffer.actions:
		apply_action(action)


func apply_action(action: CombatActionBase):
	if action is CombatActionPopTurnQueue:
		turn_queue.pop_front()
		return
	if action is CombatActionMove:
		unit(action.unit_handle).placement = action.target_hex()
		return
	if action is CombatActionAppendToTurnQueue:
		append_to_turn_queue(action.unit_handle)
		return
	if action is CombatActionMeleeAttack:
		var defending_unit := unit(action.defending)
		var stacks_died = action.damage / defending_unit.unit.combat_stats.hp
		var hp_damaged = action.damage % defending_unit.unit.combat_stats.hp
		defending_unit.hp -= hp_damaged
		defending_unit.stack_size -= stacks_died
		return
	if action is CombatActionMeleeAttack:
		apply_damage(action.defending, action.damage)
		return
	if action is CombatActionRangedAttack:
		apply_damage(action.target, action.damage)
		return


func append_to_turn_queue(unit_handle: CombatUnitHandle):
	turn_queue.append(unit_handle)


func apply_damage(unit_handle: CombatUnitHandle, damage: int):
	var defending_unit := unit(unit_handle)
	var stacks_killed := damage / defending_unit.unit.combat_stats.hp
	var hp_damage := damage % defending_unit.unit.combat_stats.hp
	var hp_left = defending_unit.hp - hp_damage
	if hp_left <= 0:
		stacks_killed += 1
		hp_left += defending_unit.unit.combat_stats.hp
	defending_unit.hp = hp_left
	defending_unit.stack_size -= stacks_killed
