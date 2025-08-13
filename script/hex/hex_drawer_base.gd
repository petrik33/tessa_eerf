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
		
func _ready() -> void:
	queue_redraw()
	
func _draw():
	if layout == null:
		return
	if grid == null:
		return
	if not grid.is_layout_compatible(layout):
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
	queue_redraw()
