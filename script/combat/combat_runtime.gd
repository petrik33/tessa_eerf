class_name CombatRuntime


func get_navigation_context() -> HexNavigationContext:
	return _nav_context


func get_pathfinding() -> HexPathfinding:
	return _pathfinding


func update(state: CombatState):
	_pathfinding.clear_disabled_points()
	for unit_handle in state.get_all_unit_handles():
		var unit := state.get_unit(unit_handle)
		_pathfinding.set_point_disabled(unit.placement, true)


func _init(definition: CombatDefinition):
	_nav_context = HexNavigationContext.new(definition.grid)
	_pathfinding = HexPathfinding.new(_nav_context)


var _nav_context: HexNavigationContext
var _pathfinding: HexPathfinding
