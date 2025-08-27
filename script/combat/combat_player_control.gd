class_name CombatPlayerControl extends Node


signal potential_command_changed(command: CombatCommandBase)


## TODO: Implement in a cleaner manner
@export var side_idx: int
@export var observer: CombatObserver
@export var combat: Combat
@export var hex_picking: HexPicking


func get_potential_command(_previous_hex: Vector2i, target_hex: Vector2i) -> CombatCommandBase:
	if not observer.runtime().navigation().grid().has_point(target_hex):
		return null
	
	var target_distance = HexMath.distance(
		observer.runtime().state().current_placement(),
		target_hex
	)
	
	if target_distance > observer.runtime().state().current_unit().stats().speed:
		return null
	
	var targeted_unit = observer.runtime().state().unit_on_hex(target_hex)
	
	if targeted_unit == null:
		return CombatCommands.move_unit(
			combat.runtime().pathfinding().id_path(
				observer.runtime().state().current_unit().placement, target_hex
			)
		)
	elif targeted_unit.is_an_enemy(side_idx):
		# TODO: Actual algorithm to find hex to attack from
		var move_path = combat.runtime().pathfinding().id_path(
			observer.runtime().state().current_unit().placement,
			target_hex
		)
		move_path.remove_at(move_path.size() - 1)
		return CombatCommands.attack_unit(
			move_path, target_hex
		)
	
	return null


var _potential_command: CombatCommandBase


func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("turn_accept") and _potential_command != null:
		combat.request_command(_potential_command)


func _handle_combat_started():
	pass


func _handle_command_processed(command: CombatCommandBase, actions: CombatActionsBuffer):
	pass


func _handle_combat_finished():
	pass


func _handle_turn_started(turn_side_idx: int):
	if side_idx != turn_side_idx:
		return
	set_process_unhandled_input(true)
	hex_picking.updated.connect(_on_hex_picking_updated)


func _handle_turn_finished(turn_side_idx: int):
	if side_idx != turn_side_idx:
		return
	hex_picking.updated.disconnect(_on_hex_picking_updated)
	set_process_unhandled_input(false)


func _on_hex_picking_updated(previous_hex: Vector2i, hex: Vector2i):
	_potential_command = get_potential_command(previous_hex, hex)
	potential_command_changed.emit(_potential_command)
