class_name CombatUI extends Node

@export var outlines: CombatUiOutlines
@export var unit_markers: CombatUiUnitMarkers

@export var cursor_arrow: Texture2D
@export var cursor_point: Texture2D
@export var cursor_attack_melee: Texture2D
@export var cursor_attack_ranged: Texture2D


func setup(initial_state: CombatState, visual: CombatVisual):
	unit_markers.create_units_left_markers(visual, initial_state)


func reset():
	unit_markers.destroy_units_left_markers()


func start_turn(turn_context: CombatTurnContext):
	enable_turn_outlines(turn_context)


func finish_turn():
	disable_turn_outlines()
	Input.set_custom_mouse_cursor(cursor_arrow)


func enable_turn_outlines(turn_context: CombatTurnContext):
	outlines.show()
	outlines.update_turn_context(turn_context)


func disable_turn_outlines():
	outlines.hide()


func update_observed_state(state: CombatState):
	unit_markers.update(state)


func update_potential_command(turn_context: CombatTurnContext, command: CombatCommandBase):
	update_cursor(command)
	outlines.update_potential_command(turn_context, command)


func update_cursor(command: CombatCommandBase):
	if command == null:
		Input.set_custom_mouse_cursor(cursor_arrow)
	elif command is CombatCommandMoveUnit:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(5, 0))
	elif command is CombatCommandMeleeAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_melee)
	elif command is CombatCommandRangedAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_ranged)
