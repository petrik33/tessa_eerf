class_name CombatServices


var navigation: HexNavigationContext
var pathfinding: HexPathfinding


func update(state: CombatState):
	pathfinding.clear_disabled_points()
	for unit_handle in state.all_unit_handles():
		var unit := state.unit(unit_handle)
		pathfinding.set_point_disabled(unit.placement, true)


func _init(definition: CombatDefinition):
	navigation = HexNavigationContext.new(definition.grid)
	pathfinding = HexPathfinding.new(navigation)
