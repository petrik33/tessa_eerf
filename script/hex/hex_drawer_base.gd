@tool
class_name HexDrawerBase extends Control

@export var layout: HexLayout:
	set(new_layout):
		if layout != null:
			layout.changed.disconnect(_update)
		layout = new_layout
		if layout != null:
			layout.changed.connect(_update)
		_update()
		
@export var grid: HexGridBase:
	set(new_grid):
		if grid != null:
			grid.changed.disconnect(_update)
		grid = new_grid
		if grid != null:
			grid.changed.connect(_update)
		_update()

func is_configured() -> bool:
	return layout != null and grid != null and grid.is_layout_compatible(layout)

func _ready() -> void:
	queue_redraw()
	
func _draw():
	if not is_configured():
		return
	_draw_impl()
	
func _get_configuration_warnings() -> PackedStringArray:
	if layout == null:
		return ["Hex layout is not assigned."]
	if grid == null:
		return ["Hex grid is not assigned."]
	if not grid.is_layout_compatible(layout):
		return [grid.layout_error_message(layout)]
	return []
	
func _draw_impl():
	assert(false, "Not implemented")
		
func _update():
	update_configuration_warnings()
	_update_size_and_pivot()
	queue_redraw()

func _update_size_and_pivot():
	if not is_configured():
		pivot_offset = Vector2.ZERO
		size = Vector2.ZERO
		return
	var approx_bounds = grid.approx_pixel_bounds(layout)
	var pivot_point = layout.hex_to_pixel(grid.pivot_point())
	pivot_offset = pivot_point - approx_bounds.position
	size = approx_bounds.size
