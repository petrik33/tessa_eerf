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


var hex_space: HexSpace = null


func _ready() -> void:
	_update_hex_space()

func _enter_tree() -> void:
	_update_hex_space()

func _exit_tree() -> void:
	_update_hex_space()

func _draw():
	if grid == null:
		return
	if hex_space == null:
		return
	_draw_impl(grid, hex_space.layout)


func _draw_impl(_grid: HexGridBase, _layout: HexLayout):
	assert(false, "Not implemented")


func _update_hex_space():
	if hex_space != null:
		hex_space.changed.disconnect(_update)
	hex_space = HexUtils.find_hex_space(self)
	if hex_space != null:
		hex_space.changed.connect(_update)
	_update()


func _update():
	update_configuration_warnings()
	queue_redraw()


func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid not configured"]
	if HexUtils.find_hex_space(self) == null:
		return ["Should be in HexSpace node child hierarchy"]
	return []
