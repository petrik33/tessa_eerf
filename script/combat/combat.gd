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
	turn_system.wait_started.connect(_on_turn_system_wait_started)
	turn_system.wait_reason_changed.connect(_on_turn_system_wait_reason_changed)
	turn_system.wait_finished.connect(_on_turn_system_wait_finished)
	_state = definition.initializer().create_initial_state()
	rules.fill_initial_state(_state)
	_services = CombatServices.new(definition)
	_services.update(_state)
	started.emit()
	var first_army_handle := _state.current_army_handle()
	turn_system.start(first_army_handle)
	turn_started.emit(first_army_handle)


func request_command(command: CombatCommandBase):
	if not rules.validate_command(command, _state, _services):
		_on_invalid_command_requested()
		return

	var turn_handle := _state.current_army_handle()

	var actions = rules.process_command(command, _state, _services)
	_state.apply_actions(actions)
	_services.update(_state)

	# TODO: possibly save state, actions or/and command

	command_processed.emit(command, actions)

	turn_finished.emit(turn_handle)

	if rules.is_combat_finished(_state):
		turn_system.finish()
		finished.emit()
	else:
		var next_turn_handle := _state.current_army_handle()
		if turn_system.progress(next_turn_handle):
			turn_started.emit(next_turn_handle)


func finish():
	turn_system.finish()
	finished.emit()
	turn_system.wait_started.disconnect(_on_turn_system_wait_started)
	turn_system.wait_reason_changed.disconnect(_on_turn_system_wait_reason_changed)
	turn_system.wait_finished.disconnect(_on_turn_system_wait_finished)


func observe_state(_observer_handle: CombatHandle = null) -> CombatState:
	return _state


func add_wait(reason: StringName):
	turn_system.add_wait(reason)


func remove_wait(reason: StringName):
	turn_system.remove_wait(reason)


func add_auto_wait(reason: StringName):
	turn_system.add_auto_wait(reason)


func remove_auto_wait(reason: StringName):
	turn_system.remove_auto_wait(reason)


var _services: CombatServices
var _state: CombatState


func _on_invalid_command_requested():
	pass


func _on_turn_system_wait_started(reason: String):
	wait_started.emit(reason)


func _on_turn_system_wait_reason_changed(new_reason: String):
	wait_reason_changed.emit(new_reason)


func _on_turn_system_wait_finished():
	wait_finished.emit()
	turn_started.emit(_state.current_army_handle())


func _connect_to_turn_system():
	turn_system.wait_started.connect(_on_turn_system_wait_started)
	turn_system.wait_reason_changed.connect(_on_turn_system_wait_reason_changed)
	turn_system.wait_finished.connect(_on_turn_system_wait_finished)


func _disconnect_from_turn_system():
	turn_system.wait_started.disconnect(_on_turn_system_wait_started)
	turn_system.wait_reason_changed.disconnect(_on_turn_system_wait_reason_changed)
	turn_system.wait_finished.disconnect(_on_turn_system_wait_finished)
