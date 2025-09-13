class_name CombatInput extends Node


signal potential_command_changed(command: CombatCommandBase)
signal command_requested(command: CombatCommandBase)


@export var intent_resolver: CombatInputIntentResolver
@export var hex_picking: HexPicking


var potential_command: CombatCommandBase
var turn_context: CombatTurnContext


func enable(context: CombatTurnContext):
	turn_context = context
	set_process_unhandled_input(true)
	hex_picking.updated.connect(_on_hex_picking_updated)
	_on_hex_picking_updated(Vector2.ZERO, hex_picking.mouse_hex)


func disable():
	hex_picking.updated.disconnect(_on_hex_picking_updated)
	set_process_unhandled_input(false)
	turn_context = null


func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("turn_accept") and potential_command != null:
		command_requested.emit(potential_command)


func _on_hex_picking_updated(previous_hex: Vector2i, hex: Vector2i):
	potential_command = intent_resolver.get_potential_command(turn_context, previous_hex, hex)
	potential_command_changed.emit(potential_command)
