class_name teCombatServices extends RefCounted


var navigation: HexNavigationContext
var pathfinding: HexPathfinding


func _init(state: teCombatState):
	navigation = HexNavigationContext.new(state.map.grid)
	pathfinding = HexPathfinding.new(navigation)
	for unit_id in state.all_units_id():
		var unit := state.unit(unit_id)
		pathfinding.set_point_disabled(unit.hex)


func sync(state: teCombatState):
	pass


func update(log: teCombatEventLog):
	pass
