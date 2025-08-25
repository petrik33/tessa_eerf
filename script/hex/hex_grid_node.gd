@tool
@icon("res://editor/icons/hex_grid_node.svg")
class_name HexGridNode extends Node2D

signal changed()

@export var grid: HexGridBase:
	set(new_grid):
		if grid != null:
			grid.changed.disconnect(_update)
		grid = new_grid
		if grid != null:
			grid.changed.connect(_update)
		_update()

func layout():
	return _hex_space.layout

func is_configured():
	return grid != null and _hex_space != null and _hex_space.is_configured() and grid.is_layout_compatible(layout())

var _hex_space: HexSpace

func _enter_tree() -> void:
	_update_parent()

func _exit_tree() -> void:
	_update_parent()

func _update_parent():
	if _hex_space != null:
		_hex_space.changed.disconnect(_update)
	_hex_space = get_parent() as HexSpace
	if _hex_space != null:
		_hex_space.changed.connect(_update)
	_update()

func _update():
	update_configuration_warnings()
	changed.emit()

func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid is not assigned"]
	if _hex_space == null:
		return ["Should be child of Hex Space node"]
	if not _hex_space.is_configured():
		return ["Hex Space not configured"]
	if not grid.is_layout_compatible(layout()):
		return [grid.layout_error_message(layout())]
	return []
