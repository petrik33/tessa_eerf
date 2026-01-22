extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_toggle_fullscreen"):
		var window_mode := DisplayServer.window_get_mode()
		if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
