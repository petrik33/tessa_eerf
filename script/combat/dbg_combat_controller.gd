class_name DbgCombatController extends Node

@export var combat: Combat
@export var coordinates: HexGridRendererBase

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		combat.start()
	elif event.is_action_pressed("dbg_finish_combat"):
		combat.finish()
	elif event.is_action_pressed("dbg_toggle_hex_coordinates"):
		coordinates.visible = not coordinates.visible
