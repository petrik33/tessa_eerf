@tool

class_name ButtonWithPadding extends Button


func _notification(what):
	if what == NOTIFICATION_DRAW or what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_update_child()


func _update_child():
	var child = get_child(0)
	if not child or not (child is Control):
		return

	var stylebox := _current_stylebox()
	if not stylebox:
		return
	
	var child_control := child as Control

	var margin_left = stylebox.get_margin(SIDE_LEFT)
	var margin_top = stylebox.get_margin(SIDE_TOP)
	var margin_right = stylebox.get_margin(SIDE_RIGHT)
	var margin_bottom = stylebox.get_margin(SIDE_BOTTOM)

	var available_rect = Rect2(
		margin_left,
		margin_top,
		size.x - margin_left - margin_right,
		size.y - margin_top - margin_bottom
	)
	
	child_control.position = available_rect.position
	child_control.size = available_rect.size


func _current_stylebox() -> StyleBox:
	if disabled:
		return get_theme_stylebox("disabled")
	elif button_pressed:
		return get_theme_stylebox("pressed")
	elif is_hovered():
		return get_theme_stylebox("hover")
	else:
		return get_theme_stylebox("normal")
