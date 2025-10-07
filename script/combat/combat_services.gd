class_name CombatServices


var navigation: HexNavigationContext
var pathfinding: HexPathfinding


func update(state: CombatState):
	pathfinding.clear_disabled_points()
	for unit_handle in state.all_unit_handles():
		var unit := state.unit(unit_handle)
		pathfinding.set_point_disabled(unit.placement, true)


func unit_move_path(from: Vector2i, to: Vector2i) -> PackedInt64Array:
	var was_disabled := false
	if pathfinding.is_point_disabled(from):
		pathfinding.set_point_disabled(from, false)
		was_disabled = true
	var path := pathfinding.id_path(from, to)
	if was_disabled:
		pathfinding.set_point_disabled(from)
	return path


func _init(definition: CombatDefinition):
	navigation = HexNavigationContext.new(definition.grid)
	pathfinding = HexPathfinding.new(navigation)
