@tool
class_name HexMapRendererBase extends Control

func is_configured() -> bool:
	return _hex_map != null and _hex_map.is_configured() and (_subset == null or _subset.is_configured())

func get_grid_to_draw() -> HexGridBase:
	return _hex_map.grid if _subset == null else _subset.get_map_intersection()

var _hex_map: HexMap
var _subset: HexMapSubset

func _enter_tree() -> void:
	_update_setup()

func _exit_tree() -> void:
	_update_setup()

func _ready() -> void:
	_update()

func _draw():
	if not is_configured():
		return
	_draw_impl(get_grid_to_draw(), _hex_map.layout)

func _draw_impl(_grid: HexGridBase, _layout: HexLayout):
	assert(false, "Not implemented")

func _update_setup():
	if _subset != null:
		_subset.changed.disconnect(_update)
	elif _hex_map != null:
		_hex_map.changed.disconnect(_update)
		
	_subset = get_parent() as HexMapSubset
	
	if _subset != null:
		_subset.changed.connect(_update)
		_hex_map = _subset.get_parent() as HexMap
	else:
		_hex_map = get_parent() as HexMap
		if _hex_map != null:
			_hex_map.changed.connect(_update)
	
	_update()

func _update():
	update_configuration_warnings()
	_update_size_and_pivot()
	queue_redraw()

func _update_size_and_pivot():
	if not is_configured():
		pivot_offset = Vector2.ZERO
		size = Vector2.ZERO
		return
	var approx_bounds = get_grid_to_draw().approx_pixel_bounds(_hex_map.layout)
	var pivot_point = _hex_map.layout.hex_to_pixel(
		_hex_map.grid.pivot_point() if _subset == null else _subset.grid.pivot_point()
	)
	pivot_offset = pivot_point - approx_bounds.position
	size = approx_bounds.size

func _get_configuration_warnings() -> PackedStringArray:
	if not is_configured():
		return ["Hex map renderer should be a child of HexMap or HexSubset node"]
	return []
