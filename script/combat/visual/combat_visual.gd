class_name CombatVisual extends Node

signal setup_finished()
signal reset_finished()

@export var combat: Combat
@export var writer: CombatVisualWriter
@export var director: CombatVisualDirector


func get_unit_physical_node(unit_idx: int) -> Node2D:
	return director.get_unit(unit_idx).get_physical_node()


func _handle_command_processed(command: CombatCommandBase, buffer: CombatActionsBuffer):
	director.play(writer.sequence(combat.runtime(), command, buffer))


func _handle_combat_started():
	director.setup_scene(combat.runtime())
	director.play(writer.intro(combat.runtime()))
	setup_finished.emit()


func _handle_combat_finished():
	# TODO: Play outro
	director.clear_scene()
	reset_finished.emit()
