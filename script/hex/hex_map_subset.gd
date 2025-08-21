@tool
class_name HexMapSubset extends Node2D

signal changed()

@export var grid: HexGridBase:
	set(new_grid):
		if grid != null:
			grid.changed.disconnect(_update)
		grid = new_grid
		if grid != null:
			grid.changed.connect(_update)
		_update()

func is_configured() -> bool:
	return grid != null and _hex_map != null and grid.is_layout_compatible(_hex_map.layout)

func get_map_intersection() -> IntersectionHexGrid:
	return HexGrids.intersection(_hex_map.grid, grid)

var _hex_map: HexMap

func _enter_tree() -> void:
	_update_parent()

func _exit_tree() -> void:
	_update_parent()

func _update_parent():
	_hex_map = get_parent() as HexMap
	_update()

func _update():
	update_configuration_warnings()
	changed.emit()

func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid is not assigned."]
	if _hex_map == null:
		return ["Should be child of Hex Map node"]
	if not grid.is_layout_compatible(_hex_map.layout):
		return [grid.layout_error_message(_hex_map.layout)]
	return []
