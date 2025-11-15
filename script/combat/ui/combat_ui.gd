class_name CombatUI extends Node


signal potential_command_changed(command: CombatCommandBase)
signal command_requested(command: CombatCommandBase)


@export var input: CombatInput
@export var outlines: CombatUiOutlines
@export var unit_markers: CombatUiUnitMarkers

@export var cursor_arrow: Texture2D
@export var cursor_point: Texture2D
@export var cursor_attack_melee: Texture2D
@export var cursor_attack_ranged: Texture2D

@export var modules: Array[CombatUiModuleBase]


var turn_context: CombatTurnContext


func setup(initial_state: CombatState, visual: CombatVisual):
	input.potential_command_changed.connect(_on_potential_command_changed)
	input.command_requested.connect(_on_command_requested)
	for module in modules:
		module.command_requested.connect(_on_command_requested)
		module.setup(initial_state, visual)
		module.update(initial_state)


func reset():
	for module in modules:
		module.reset()
		module.command_requested.disconnect(_on_command_requested)
	input.potential_command_changed.disconnect(_on_potential_command_changed)
	input.command_requested.disconnect(_on_command_requested)


func start_turn(_turn_context: CombatTurnContext):
	turn_context = _turn_context
	outlines.show()
	outlines.update_turn_context(turn_context)
	input.enable(turn_context)
	for module in modules:
		module.start_turn(_turn_context)


func finish_turn():
	for module in modules:
		module.finish_turn()
	Input.set_custom_mouse_cursor(cursor_arrow)
	input.disable()
	outlines.hide()


func update_observed_state(state: CombatState):
	for module in modules:
		module.update(state)


func update_cursor(command: CombatCommandBase):
	if command == null:
		Input.set_custom_mouse_cursor(cursor_arrow)
	elif command is CombatCommandMoveUnit:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(5, 0))
	elif command is CombatCommandMeleeAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_melee)
	elif command is CombatCommandRangedAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_ranged)


func _on_potential_command_changed(command: CombatCommandBase):
	update_cursor(command)
	outlines.update_potential_command(turn_context, command)
	potential_command_changed.emit(command)


func _on_command_requested(command: CombatCommandBase):
	command_requested.emit(command)
