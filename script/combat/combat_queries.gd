class_name CombatQueries

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

static func get_enemies(state: CombatState, ally_army_handle: CombatArmyHandle) -> Array[CombatUnit]:
	return state.get_all_units().filter(
		func(unit: CombatUnit): return unit.is_an_enemy(ally_army_handle)
	)

static func get_enemies_placement(state: CombatState, ally_army_handle: CombatArmyHandle) -> Array[Vector2i]:
	return get_enemies(state, ally_army_handle).map(
		func(unit): return unit.placement
	)

static func get_allies(state: CombatState, ally_army_handle: CombatArmyHandle) -> Array[CombatUnit]:
	return state.get_all_units().filter(
		func(unit: CombatUnit): return unit.is_an_ally(ally_army_handle)
	)

static func find_unit_handle_by_placement_hex(state: CombatState, hex: Vector2i) -> CombatUnitHandle:
	var idx = 0
	for unit in state.get_all_units():
		if unit.placement == hex:
			return CombatUnitHandle.new(idx)
		idx += 1
	return null
