class_name DbgCombatController extends Node

@export var combat: Combat

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		combat.start()
	elif event.is_action_pressed("dbg_finish_combat"):
		combat.finish()
