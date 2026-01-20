@tool
class_name acBoardView extends Node2D


@export var hex_space: HexSpace
@export var unit_views: Array[acUnitView]


func sync_unit_positions_from_state(state: acBattleState):
	for unit in state.units.values():
		var unit_view := unit_views[unit.uid]
		unit_view.position = hex_space.layout.hex_to_pixel(unit.hex)


func get_unit_view(uid: int) -> acUnitView:
	return unit_views[uid]
