class_name CombatPlayerControl extends Node

## TODO: Implement in a cleaner manner
@export var side_idx: int
@export var combat: Combat

@export var hex_map: HexMap
@export var hex_layout: HexLayout

@export var unit_outline: HexMapSubset
@export var move_range_outline: HexMapSubset
@export var mouse_pick_outline: HexMapSubset
@export var enemies_outline: HexMapSubset
@export var allies_outline: HexMapSubset
@export var move_path_outline: HexMapSubset

enum Cursor {
	ARROW,
	POINT,
	ATTACK_MELEE,
	ATTACK_RANGED
}

@export var cursor_arrow: Texture2D
@export var cursor_point: Texture2D
@export var cursor_attack_melee: Texture2D
	
var _turn_started = false

var _previous_mouse_hex := Vector2i(0, 0)
var _mouse_hex := Vector2i(0, 0)

var _local_state: CombatState
var _potential_command: CombatCommandBase

func _handle_combat_started():
	_local_state = combat.runtime().state()
	pass

func _handle_command_processed(command: CombatCommandBase, actions: CombatActionsBuffer):
	pass

func _handle_combat_finished():
	pass

func _handle_turn_started(turn_side_idx: int):
	if side_idx != turn_side_idx:
		return
	_turn_started = true
	_update_turn_outlines()
	_show_outlines()
	set_process_unhandled_input(true)
	_handle_mouse_motion(get_viewport().get_mouse_position(), true)

func _handle_turn_finished(turn_side_idx: int):
	if side_idx != turn_side_idx:
		return
	_turn_started = false
	set_process_unhandled_input(false)
	_hide_outlines()

func _unhandled_input(event: InputEvent):
	if not _turn_started:
		return
	if event.is_action_pressed("turn_accept") and _potential_command != null:
		combat.request_command(_potential_command)
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event.position)

func _update_potential_command():
	_potential_command = null
	
	if not combat.runtime().navigation().grid().has_point(_mouse_hex):
		return
	
	var target_distance = HexMath.distance(
		_local_state.current_placement(),
		_mouse_hex
	)
	
	if target_distance > _local_state.current_unit().stats().speed:
		return
	
	var targeted_unit = _local_state.unit_on_hex(_mouse_hex)
	
	if targeted_unit == null:
		_potential_command = CombatCommandMoveUnit.new()
		_potential_command.id_path = combat.runtime().pathfinding().id_path(
			_local_state.current_unit().placement,
			_mouse_hex
		)
	elif targeted_unit.is_an_enemy(side_idx):
		_potential_command = CombatCommandAttackUnit.new()
		_potential_command.attacked_hex = _mouse_hex
		_potential_command.move_id_path = combat.runtime().pathfinding().id_path(
			_local_state.current_unit().placement,
			_mouse_hex
		)
		_potential_command.move_id_path.remove_at(_potential_command.move_id_path.size() - 1)

func _handle_mouse_motion(position: Vector2, force_update = false):
	var hex = hex_layout.pixel_to_hex(position - hex_map.position)
	if _mouse_hex == hex and not force_update:
		return
	_previous_mouse_hex = _mouse_hex
	_mouse_hex = hex
	_update_potential_command()
	_update_custom_cursor()
	_update_mouse_outline()
	
func _update_mouse_outline():
	if _potential_command == null:
		mouse_pick_outline.hide()
		return
	mouse_pick_outline.show()
	mouse_pick_outline.grid = HexGrids.point(_mouse_hex)

func _update_move_path_outline():
	if _potential_command == null:
		move_path_outline.hide()
	elif _potential_command is CombatCommandAttackUnit:
		move_path_outline.grid = HexGrids.points(
			combat.runtime().navigation().path(_potential_command.move_id_path)
		)
		move_path_outline.show()
	elif _potential_command is CombatCommandMoveUnit:
		move_path_outline.grid = HexGrids.points(
			combat.runtime().navigation().path(_potential_command.id_path)
		)
		move_path_outline.show()

func _update_turn_outlines():
	var current_unit = _local_state.current_unit()
	unit_outline.grid = HexGrids.point(
		current_unit.placement
	)
	move_range_outline.grid = HexGrids.ranged(
		current_unit.placement,
		current_unit.stats().speed
	)
	enemies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, _local_state.enemies(side_idx).map(
			func(unit: CombatUnitState): return unit.placement
		))
	)
	allies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, _local_state.allies(side_idx)
			.filter(
				func(unit: CombatUnitState): return unit != current_unit
			)
			.map(
				func(unit: CombatUnitState): return unit.placement
			)
		)
	)
	
func _show_outlines():
	unit_outline.show()
	move_range_outline.show()
	enemies_outline.show()
	allies_outline.show()

func _hide_outlines():
	allies_outline.hide()
	enemies_outline.hide()
	unit_outline.hide()
	move_range_outline.hide()
	mouse_pick_outline.hide()
	move_path_outline.hide()

func _update_custom_cursor():
	if _potential_command == null:
		Input.set_custom_mouse_cursor(cursor_arrow)
	elif _potential_command is CombatCommandMoveUnit:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(5, 0))
	elif _potential_command is CombatCommandAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_melee, Input.CURSOR_ARROW)
