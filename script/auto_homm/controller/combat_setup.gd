class_name teCombatSetupController extends Node


signal place_unit_requested(unit_id: int, hex: Vector2i)


@export var hex_picking: HexPicking
@export var board: teBoardVisual


var current_team: teCombatTeam
var selected_unit_id := -1


func is_active() -> bool:
	return current_team != null


func activate(team: teCombatTeam):
	current_team = team
	hex_picking.hovered.connect(_on_hex_hovered)
	hex_picking.clicked.connect(_on_hex_clicked)
	hex_picking.left_grid.connect(_on_hex_grid_left)


func deactivate():
	hex_picking.hovered.disconnect(_on_hex_hovered)
	hex_picking.clicked.disconnect(_on_hex_clicked)
	hex_picking.left_grid.disconnect(_on_hex_grid_left)
	current_team = null


func clear_unit_selection():
	if selected_unit_id == -1:
		return
	board.deselect_unit(selected_unit_id)
	selected_unit_id = -1


func select_unit(unit_id: int):
	clear_unit_selection()
	selected_unit_id = unit_id
	board.select_unit(unit_id)


func try_deselect_unit(unit_id: int):
	if unit_id != selected_unit_id:
		return false
	clear_unit_selection()
	return true


func _on_hex_hovered(hex: Vector2i, _previous: Vector2i):
	board.clear_units_hover()

	var unit_id := current_team.unit_id_at_hex(hex)
	if unit_id != -1:
		board.hover_unit(unit_id)
	
	board.hover_hex(hex)


func _on_hex_clicked(hex: Vector2i, event: InputEventMouseButton):
	if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var clicked_unit_id := current_team.unit_id_at_hex(hex)
		if clicked_unit_id == -1:
			if selected_unit_id != -1:
				place_unit_requested.emit(selected_unit_id, hex)
				clear_unit_selection()
			return
		if try_deselect_unit(clicked_unit_id):
			return
		select_unit(clicked_unit_id)


func _on_hex_grid_left(_last_hex: Vector2i):
	board.clear_all_hover()
