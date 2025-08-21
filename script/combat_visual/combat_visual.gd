class_name CombatVisual extends Node

@export var combat: Combat
@export var writer: CombatVisualWriter
@export var director: CombatVisualDirector
	
func _handle_command_processed(command: CombatCommandBase, buffer: CombatActionsBuffer):
	director.play(writer.sequence(combat.runtime(), command, buffer))

func _handle_combat_started():
	director.setup_scene(combat.runtime())
	director.play(writer.intro(combat.runtime()))

func _handle_combat_finished():
	# TODO: Play outro
	director.clear_scene()
