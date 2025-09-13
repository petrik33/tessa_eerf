class_name CombatHotSeatController extends CombatController


@export var controlled_armies: Array[String]
@export var input: CombatInput


func setup():
	input.potential_command_changed.connect(_on_input_potential_command_changed)
	input.command_requested.connect(_on_input_command_requested)


func reset():
	input.potential_command_changed.disconnect(_on_input_potential_command_changed)
	input.command_requested.disconnect(_on_input_command_requested)


func is_turn_controlled(turn_handle: CombatHandle):
	var army_id := turn_handle.id()
	return controlled_armies.has(army_id)


func enable(turn_context: CombatTurnContext):
	input.enable(turn_context)
	


func disable():
	input.disable()


func _on_input_potential_command_changed(command: CombatCommandBase):
	potential_command_changed.emit(command)


func _on_input_command_requested(command: CombatCommandBase):
	command_requested.emit(command)
