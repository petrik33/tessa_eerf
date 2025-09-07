class_name CombatPlayer extends Node


signal turn_started()
signal turn_finished()


@export var combat: Combat
@export var army_handle: CombatArmyHandle


func get_army_handle() -> CombatArmyHandle:
	return army_handle


func get_observed_state() -> CombatState:
	return _observed_state


func get_runtime() -> CombatRuntime:
	return _runtime


var _observed_state: CombatState
var _runtime: CombatRuntime


func _on_combat_started():
	_runtime = CombatRuntime.new(combat.definition)


func _on_combat_finished():
	_runtime.free()


func _on_combat_command_processed(_command: CombatCommandBase, _actions: CombatActionsBuffer):
	_observed_state = combat.observe_state(army_handle)
	_runtime.update(_observed_state)


func _on_combat_turn_started(turn_handle: CombatHandle):
	if not turn_handle.is_equal(army_handle):
		return

	turn_started.emit()


func _on_combat_turn_finished(turn_handle: CombatHandle):
	if not turn_handle.is_equal(army_handle):
		return

	turn_finished.emit()
