@tool
class_name acBoardView extends Node2D


@export var hex_space: HexSpace
@export var unit_views: Array[acUnitView]


func sync(state: acBattleState):
	sync_unit_positions_from_state(state)
	for uid in state.units:
		var unit := state.units[uid]
		var view := unit_views[uid]
		view.sync_from_state(unit)


func interpolate(prev_state: acBattleState, curr_state: acBattleState, alpha: float) -> void:
	interpolate_unit_positions(prev_state, curr_state, alpha)
	

func interpolate_unit_positions(prev_state: acBattleState, curr_state: acBattleState, alpha: float):
	for uid in curr_state.units:
		var unit := curr_state.units[uid]
		var unit_view := unit_views[uid]
		unit_view.position = interpolate_unit_position(
			prev_state.units[uid],
			curr_state.units[uid],
			alpha
		)


func sync_unit_positions_from_state(state: acBattleState):
	for uid in state.units:
		var unit := state.units[uid]
		var unit_view := unit_views[uid]
		unit_view.position = calc_unit_position(unit)


func get_unit_view(uid: int) -> acUnitView:
	return unit_views[uid]


func interpolate_unit_position(prev_state: acUnitState, curr_state: acUnitState, alpha: float) -> Vector2:
	var prev_pos := calc_unit_position(prev_state)
	var curr_pos := calc_unit_position(curr_state)
	return lerp(prev_pos, curr_pos, alpha)


func calc_unit_position(unit: acUnitState) -> Vector2:
	var current_hex_position := hex_space.layout.hex_to_pixel(unit.hex)
	if not unit.is_moving():
		return current_hex_position
	var next_hex_position := hex_space.layout.hex_to_pixel(unit.movement_target_hex)
	return lerp(current_hex_position, next_hex_position, unit.movement_progress)
