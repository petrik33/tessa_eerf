@tool
class_name acBattleController extends Node

@export var board_view: acBoardView
@export var hex_space: HexSpace
@export var combined_grid: HexGridBase
@export var ally_grid: HexGridBase
@export var hover_ui: HexGridRendererBase
@export var unit_view_scenes: Dictionary[StringName, PackedScene]
@export var unit_definitions: Dictionary[StringName, acUnit]

@export var selected_unit: acUnitState
@export var state: acBattleState

@export_tool_button("Fill State")
var fill_state_button = fill_state_from_view


const ALLY_TEAM := 0
const ENEMY_TEAM := 1


func sync_views():
	board_view.sync_unit_positions_from_state(state)
	for unit in state.units.values():
		var view = board_view.get_unit_view(unit.uid)
		view.sync_from_state(unit)


func fill_state_from_view():
	state = acBattleState.new()
	state.board = acBoardState.new()
	state.teams[ALLY_TEAM] = acTeamState.new()
	state.teams[ENEMY_TEAM] = acTeamState.new()
	
	var unit_next_uid := 0
	
	for unit_view in board_view.unit_views:
		var unit := acUnitState.new()
		unit.uid = unit_next_uid
		unit.definition = unit_definitions.get(
			try_find_unit_definition_uid_by_view(unit_view)
		)
		unit.hex = hex_space.layout.pixel_to_hex(unit_view.position)
		unit.team = 0 if ally_grid.has_point(unit.hex) else 1
		unit.hp = unit.definition.max_hp
		unit.mana = 0
		unit.facing = unit.team
		state.units[unit.uid] = unit
		state.board.units[unit.hex] = unit
		state.teams[unit.team].units.append(unit)
		unit_next_uid += 1
	
	for hex in combined_grid.iterator():
		state.board.tiles[hex] = acTileState.new()


func try_find_unit_definition_uid_by_view(unit_view: acUnitView) -> StringName:
	var scene_path := unit_view.scene_file_path
	for key in unit_view_scenes.keys():
		if unit_view_scenes[key].resource_path == scene_path:
			return key
	return ""


func try_deselect_unit(unit: acUnitState) -> bool:
	if unit != selected_unit:
		return false
	clear_unit_selection()
	return true


func try_select_unit(unit: acUnitState) -> bool:
	if unit.team != ALLY_TEAM:
		return false
	
	clear_unit_selection()
	
	selected_unit = unit
	board_view.get_unit_view(unit.uid).set_selected(true)
	
	return true


func try_issue_move(hex: Vector2i) -> bool:
	if selected_unit == null:
		return false
	if not state.is_valid_move(selected_unit, hex):
		return false
	
	state.issue_move(selected_unit, hex)
	sync_views()
	hover_unit(selected_unit)
	clear_unit_selection()
	
	return true


func hover_unit(unit: acUnitState):
	board_view.get_unit_view(unit.uid).set_hovered(true)


func clear_units_hover():
	for unit_view in board_view.unit_views:
		unit_view.set_hovered(false)


func clear_unit_selection():
	if selected_unit == null:
		return
	board_view.get_unit_view(selected_unit.uid).set_selected(false)
	selected_unit = null


func _on_hex_hovered(hex: Vector2i, _previous: Vector2i):
	clear_units_hover()

	var unit = state.get_unit_at_hex(hex)
	if unit:
		hover_unit(unit)
	
	hover_ui.grid = HexGrids.point(hex)


func _on_hex_clicked(hex: Vector2i, event: InputEventMouseButton):
	if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var clicked_unit = state.get_unit_at_hex(hex)
		if clicked_unit == null:
			try_issue_move(hex)
			return
		if try_deselect_unit(clicked_unit):
			return
		try_select_unit(clicked_unit)


func _on_hex_grid_left(_last_hex: Vector2i):
	clear_units_hover()
	hover_ui.grid = null
