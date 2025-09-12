class_name CombatController extends Node


signal potential_command_changed(command: CombatCommandBase)
signal command_requested(command: CombatCommandBase)


func setup():
	pass


func reset():
	pass


func is_turn_controlled(turn_handle: CombatHandle) -> bool:
	assert(false, "not implemented")
	return false


func enable(turn_context: CombatTurnContext) -> void:
	assert(false, "not implemented")


func disable() -> void:
	assert(false, "not implemented")
