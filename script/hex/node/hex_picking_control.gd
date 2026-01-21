@tool
class_name HexPickingControl extends Control


signal hovered(previous_hex: Vector2i, hex: Vector2i)
signal clicked(hex: Vector2i, event: InputEventMouseButton)
signal left(last_hex: Vector2i)

@export var bbox_expand_left := 0.0:
	set(value):
		bbox_expand_left = value
		_update()

@export var bbox_expand_top := 0.0:
	set(value):
		bbox_expand_top = value
		_update()

@export var bbox_expand_right := 0.0:
	set(value):
		bbox_expand_right = value
		_update()

@export var bbox_expand_bottom := 0.0:
	set(value):
		bbox_expand_bottom = value
		_update()

@export var grid: HexGridBase:
	set(new_grid):
		if grid != null:
			grid.changed.disconnect(_update)
		grid = new_grid
		if grid != null:
			grid.changed.connect(_update)
		_update()


var mouse_hex := Vector2i(0, 0)


func is_configured():
	return grid != null and _hex_space != null and _hex_space.is_configured() and grid.is_layout_compatible(_hex_space.layout)


var _hex_space: HexSpace


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_on_mouse_motion(event)
	if event is InputEventMouseButton and event.pressed and grid.has_point(mouse_hex):
		clicked.emit(mouse_hex, event)


func _enter_tree() -> void:
	_update_parent()


func _exit_tree() -> void:
	_update_parent()


func _on_mouse_motion(event: InputEventMouseMotion):
	var hex = _hex_space.layout.pixel_to_hex(event.position - pivot_offset)
	if mouse_hex == hex:
		return
	hovered.emit(mouse_hex, hex)
	mouse_hex = hex


func _update_parent():
	if _hex_space != null:
		_hex_space.changed.disconnect(_update)
	_hex_space = get_parent() as HexSpace
	if _hex_space != null:
		_hex_space.changed.connect(_update)
	_update()


func _update():
	_update_size_and_pivot()
	update_configuration_warnings()


func _update_size_and_pivot():
	if not is_configured():
		size = Vector2.ZERO
		pivot_offset = Vector2.ZERO
		return
	var bounds := grid.approx_pixel_bounds(_hex_space.layout)
	bounds.position -= Vector2(bbox_expand_left, bbox_expand_top)
	bounds.size += Vector2(bbox_expand_left + bbox_expand_right, bbox_expand_bottom + bbox_expand_top)
	#var scaled_bounds_size := bounds.size * bbox_scale
	#bounds = Rect2(
		#bounds.get_center() - (scaled_bounds_size * 0.5),
		#scaled_bounds_size
	#)
	# TODO: Implement pivot point getter for hex grids
	var pivot_point = _hex_space.layout.hex_to_pixel(Vector2i.ZERO)
	position = bounds.position
	pivot_offset = pivot_point - bounds.position
	size = bounds.size


func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid is not assigned"]
	if _hex_space == null:
		return ["Should be child of Hex Space node"]
	if not _hex_space.is_configured():
		return ["Hex Space not configured"]
	if not grid.is_layout_compatible(_hex_space.layout):
		return [grid.layout_error_message(_hex_space.layout)]
	return []
