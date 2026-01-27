@tool
class_name acBoardView extends Node2D


@export var hex_space: HexSpace
@export var unit_views: Array[acUnitView]


func sync_unit_positions_from_state(state: acBattleState):
	for uid in state.units:
		var unit := state.units[uid]
		var unit_view := unit_views[uid]
		unit_view.position = calc_unit_position(unit)


func get_unit_view(uid: int) -> acUnitView:
	return unit_views[uid]


func calc_unit_position(unit: acUnitState) -> Vector2:
	var current_hex_position := hex_space.layout.hex_to_pixel(unit.hex)
	if not unit.is_moving():
		return current_hex_position
	var next_hex_position := hex_space.layout.hex_to_pixel(unit.movement_target_hex)
	return lerp(current_hex_position, next_hex_position, unit.movement_progress)
