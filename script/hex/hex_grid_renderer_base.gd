@tool
class_name HexGridRendererBase extends Node2D

@export var grid: HexGridBase:
	set(value):
		if grid != null:
			grid.changed.disconnect(_update)
		grid = value
		if grid != null:
			grid.changed.connect(_update)
		_update()

func _ready() -> void:
	_update()

func _enter_tree() -> void:
	_update()

func _exit_tree() -> void:
	_update()

func _draw():
	if grid == null:
		return
	var hex_space := HexUtils.find_hex_space(self)
	if hex_space == null:
		return
	_draw_impl(grid, hex_space.layout)

func _draw_impl(_grid: HexGridBase, _layout: HexLayout):
	assert(false, "Not implemented")

func _update():
	update_configuration_warnings()
	queue_redraw()

func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid not configured"]
	if HexUtils.find_hex_space(self) == null:
		return ["Should be in HexSpace node child hierarchy"]
	return []
