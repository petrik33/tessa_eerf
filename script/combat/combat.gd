class_name Combat extends Node

signal combat_started()
signal command_processed(command: CombatCommandBase, actions: CombatActionsBuffer)
signal combat_finished()

@export var definition: CombatDefinition
@export var rules: CombatRules
@export var turn_system: CombatTurnSystem

func start():
	var initial_state = rules.get_initial_state(definition)
	_runtime = CombatRuntime.new(definition, initial_state)
	combat_started.emit()
	turn_system.start_combat(get_current_side_idx())

func request_command(command: CombatCommandBase):
	if not rules.validate_command(command, _runtime):
		_handle_invalid_command_requested()
		return
	
	var actions = rules.process_command(command, _runtime)
	_runtime.state().apply_actions(actions)
	
	# TODO: possibly save state, actions or command
	
	command_processed.emit(command, actions)
	
	if rules.is_combat_finished(_runtime.state()):
		turn_system.finish_combat()
	else:
		turn_system.progress_combat(rules.get_current_combat_side_idx(_runtime.state()))

func finish():
	turn_system.finish_combat()
	combat_finished.emit()

func get_current_side_idx() -> int:
	return rules.get_current_combat_side_idx(_runtime.state())

func runtime() -> CombatRuntime:
	return _runtime

var _runtime: CombatRuntime

func _handle_invalid_command_requested():
	pass
