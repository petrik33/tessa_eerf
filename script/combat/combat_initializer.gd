class_name CombatInitializer extends Object


func is_finished() -> bool:
	return is_last_army() and is_last_unit_in_army()


func is_last_army() -> bool:
	return _army_idx == _definition.armies.size() - 1


func is_first_unit_in_army() -> bool:
	return _unit_idx == 0


func is_last_unit_in_army() -> bool:
	return _unit_idx == _definition.armies[_army_idx].units.size() - 1


func next() -> void:
	if is_finished():
		return
	_unit_idx += 1
	if _unit_idx >= _definition.armies[_army_idx].units.size():
		_unit_idx = 0
		_army_idx += 1


func get_current_unit() -> CombatUnit:
	var unit_definition = _definition.armies[_army_idx].units[_unit_idx]
	var unit = CombatUnit.new()
	unit.unit = unit_definition.stack.unit
	unit.stack_size = unit_definition.stack.size
	unit.hp = unit.unit.combat_stats.hp
	unit.placement = unit_definition.placement
	return unit


var _definition: CombatDefinition
var _army_idx := 0
var _unit_idx := 0


func _init(definition: CombatDefinition) -> void:
	_definition = definition
