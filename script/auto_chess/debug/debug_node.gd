extends Node


@export var controller: acBattleController


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat") and controller != null:
		controller.start_battle()
	if event.is_action_pressed("dbg_finish_combat") and controller != null:
		controller.stop_battle()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_toggle_fullscreen"):
		var window_mode := DisplayServer.window_get_mode()
		if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
