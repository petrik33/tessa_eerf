class_name Combat extends Node

signal combat_started()
signal command_processed(command: CombatCommandBase, actions: CombatActionsBuffer)
signal combat_finished()

@export var config: CombatConfig
@export var rules: CombatRules
@export var turn_system: CombatTurnSystem

func start():
	var initial_state = rules.get_initial_state(config)
	_context = CombatContext.new(config, initial_state)
	combat_started.emit()
	turn_system.start_combat(get_current_side_idx())

func request_command(command: CombatCommandBase):
	if not rules.validate_command(command, _context):
		_handle_invalid_command_requested()
		return
	
	var actions = rules.process_command(command, _context)
	_context.state().apply_actions(actions)
	
	# TODO: possibly save state, actions or command
	
	if rules.is_combat_finished(_context.state()):
		turn_system.finish_combat()
	else:
		turn_system.progress_combat(rules.get_current_combat_side_idx(_context.state()))
	
	command_processed.emit(command, actions)

func finish():
	turn_system.finish_combat()
	combat_finished.emit()

func get_current_side_idx() -> int:
	return rules.get_current_combat_side_idx(_context.state())

func context() -> CombatContext:
	return _context

var _context: CombatContext

func _handle_invalid_command_requested():
	pass
