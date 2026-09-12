class_name teHeroCombatController extends Node


signal command_requested(command: teCombatCommandBase)


@export var board: teBoardVisual
@export var hex_picking: HexPicking
@export var ui: teCombatUI


var auto_command: teCombatCommandBase
var current_state: teCombatState


func activate(
	state: teCombatState,
	runtime: teCombatRuntime,
	command: teCombatCommandBase
):
	auto_command = command
	current_state = state
	var active_unit_id := state.active_unit_id()
	if command is teCombatCommandAttack:
		var auto_target_hex := state.unit(command.target_id).hex
		ui.outline_auto_target_hex(HexGrids.point(auto_target_hex))
		var possible_targets := teCombatTargeting.all_valid(
			state,
			active_unit_id,
			teCombatTargetQueryEnemies.new()
		)
		var enemy_hex: Array[Vector2i] = []
		for target in possible_targets:
			var enemy_target := target as teCombatTargetUnit
			enemy_hex.append(state.unit(enemy_target.single()).hex)
		ui.outline_target_hex(HexGrids.points(enemy_hex), teCombatUI.TargetOutline.ATTACK)
	hex_picking.hovered.connect(_on_hex_hovered)
	hex_picking.clicked.connect(_on_hex_clicked)
	hex_picking.left_grid.connect(_on_hex_grid_left)


func deactivate():
	board.clear_all_hover()
	hex_picking.hovered.disconnect(_on_hex_hovered)
	hex_picking.clicked.disconnect(_on_hex_clicked)
	hex_picking.left_grid.disconnect(_on_hex_grid_left)
	ui.clear_outlines()


func _on_hex_hovered(hex: Vector2i, _previous: Vector2i):
	board.clear_units_hover()

	var unit_id := current_state.unit_at_hex(hex)
	if unit_id != -1:
		board.hover_unit(unit_id)
	
	board.hover_hex(hex)


func _on_hex_clicked(hex: Vector2i, event: InputEventMouseButton):
	if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var clicked_unit_id := current_state.unit_at_hex(hex)
		if clicked_unit_id == -1:
			return
		if auto_command is teCombatCommandAttack:
			var command := teCombatCommands.attack(current_state.active_unit_id(), clicked_unit_id)
			command_requested.emit(command)


func _on_hex_grid_left(_last_hex: Vector2i):
	board.clear_all_hover()
