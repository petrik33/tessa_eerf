class_name DbgCombatController extends Node

@export var combat: Combat
@export var coordinates: HexGridRendererBase
@export var outlines: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		combat.start()
	elif event.is_action_pressed("dbg_finish_combat"):
		combat.finish()
	elif event.is_action_pressed("dbg_toggle_hex_coordinates"):
		coordinates.visible = not coordinates.visible
	elif event.is_action_pressed("dbg_toggle_outlines"):
		outlines.visible = not outlines.visible
	elif event.is_action_pressed("dbg_toggle_fullscreen"):
		var window_mode := DisplayServer.window_get_mode()
		if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
