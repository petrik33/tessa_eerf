@tool
class_name HexMap extends Node2D

signal changed()

@export var grid: HexGridBase:
	set(new_grid):
		if grid != null:
			grid.changed.disconnect(update_configuration_warnings)
		grid = new_grid
		if grid != null:
			grid.changed.connect(update_configuration_warnings)
		update_configuration_warnings()

@export var layout: HexLayout:
	set(new_layout):
		if layout != null:
			layout.changed.disconnect(_update)
		layout = new_layout
		if layout != null:
			layout.changed.connect(_update)
		_update()

func is_configured() -> bool:
	return layout != null and grid != null and grid.is_layout_compatible(layout)

func _update():
	update_configuration_warnings()
	changed.emit()

func _get_configuration_warnings() -> PackedStringArray:
	if layout == null:
		return ["Hex layout is not assigned."]
	if grid == null:
		return ["Hex grid is not assigned."]
	if not grid.is_layout_compatible(layout):
		return [grid.layout_error_message(layout)]
	return []
