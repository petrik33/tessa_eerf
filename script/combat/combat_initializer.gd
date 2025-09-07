class_name CombatInitializer extends Object


func create_initial_state() -> CombatState:
	var state := CombatState.new()
	var army_idx := 0
	for army_definition in _definition.armies:
		var army := CombatArmy.new()
		for unit_definition in army_definition.units:
			var unit = CombatUnit.new()
			unit.army_handle = CombatArmyHandle.new(army_idx)
			unit.unit = unit_definition.stack.unit
			unit.stack_size = unit_definition.stack.size
			unit.hp = unit.unit.combat_stats.hp
			unit.placement = unit_definition.placement
			army.units.push_back(unit)
		state.armies.push_back(army)
		army_idx += 1
	return state


var _definition: CombatDefinition


func _init(definition: CombatDefinition) -> void:
	_definition = definition
