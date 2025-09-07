class_name Combat extends Node

signal started()
signal finished()

signal command_processed(command: CombatCommandBase, actions: CombatActionsBuffer)

signal turn_started(turn_handle: CombatHandle)
signal turn_finished(turn_handle: CombatHandle)

signal wait_started(reason: StringName)
signal wait_reason_changed(new_reason: StringName)
signal wait_finished()


@export var definition: CombatDefinition
@export var rules: CombatRules
@export var turn_system: CombatTurnSystem


func start():
	_state = definition.initializer().create_initial_state()
	rules.fill_initial_state(_state)
	_runtime = CombatRuntime.new(definition)
	_runtime.update(_state)
	started.emit()
	turn_system.start_combat(_state.get_current_army_handle())


func request_command(command: CombatCommandBase):
	if not rules.validate_command(command, _state, _runtime):
		_handle_invalid_command_requested()
		return

	var actions = rules.process_command(command, _state, _runtime)
	_state.apply_actions(actions)
	_runtime.update(_state)

	# TODO: possibly save state, actions or/and command

	command_processed.emit(command, actions)

	if rules.is_combat_finished(_state):
		turn_system.finish_combat()
	else:
		turn_system.progress_combat(_state.get_current_army_handle())


func finish():
	turn_system.finish_combat()
	finished.emit()


func get_runtime() -> CombatRuntime:
	return _runtime


func observe_state(_observer_handle: CombatHandle) -> CombatState:
	return _state


func get_state() -> CombatState:
	return _state


var _runtime: CombatRuntime
var _state: CombatState


func _handle_invalid_command_requested():
	pass
