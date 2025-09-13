class_name CombatVisual extends Node


@export var writer: CombatVisualWriter
@export var director: CombatVisualDirector


func setup(state: CombatState):
	director.setup_scene(state)
	director.play(writer.intro(state))


func visualize(state: CombatState, command: CombatCommandBase, buffer: CombatActionsBuffer):
	await director.play(writer.sequence(state, command, buffer))


func reset():
	director.clear_scene()


func get_unit(unit_handle: CombatUnitHandle) -> CombatVisualUnit:
	return director.get_unit(unit_handle)
