@tool
class_name HexGridRendererBase extends Node2D

func is_configured() -> bool:
	return _grid_node != null and _grid_node.is_configured()

var _grid_node: HexGridNode

func _enter_tree() -> void:
	_update_grid_node()

func _exit_tree() -> void:
	_update_grid_node()

func _ready() -> void:
	_update()

func _draw():
	if not is_configured():
		return
	_draw_impl(_grid_node.grid, _grid_node.layout())

func _draw_impl(_grid: HexGridBase, _layout: HexLayout):
	assert(false, "Not implemented")

func _update_grid_node():
	if _grid_node != null:
		_grid_node.changed.disconnect(_update)
	_grid_node = get_parent() as HexGridNode
	if _grid_node != null:
		_grid_node.changed.connect(_update)
	_update()

func _update():
	update_configuration_warnings()
	queue_redraw()

func _get_configuration_warnings() -> PackedStringArray:
	if not is_configured():
		return ["Hex map renderer should be a child of HexGridNode"]
	return []
