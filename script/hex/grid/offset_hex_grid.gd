@tool
class_name OffsetHexGrid extends HexGridBase

@export var grid: HexGridBase:
	set(value):
		if grid != null:
			grid.changed.disconnect(emit_changed)
		grid = value
		if grid != null:
			grid.changed.connect(emit_changed)

@export var offset: Vector2i = Vector2i.ZERO:
	set(value):
		offset = value
		emit_changed()
		
func _init(_grid: HexGridBase = null, _offset: Vector2i = Vector2i.ZERO):
	grid = _grid
	offset = _offset

func iterator() -> HexGridIteratorBase:
	return OffsetHexGridIterator.new(grid, offset)

func has_point(hex: Vector2i) -> bool:
	return grid.has_point(hex - offset)
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var base_bounds = grid.approx_pixel_bounds(layout)
	var offset_pixel = layout.hex_to_pixel(offset)
	return Rect2(base_bounds.position + offset_pixel, base_bounds.size)

func is_layout_compatible(layout: HexLayout) -> bool:
	return grid.is_layout_compatible(layout)

func layout_error_message(layout: HexLayout) -> String:
	if not grid.is_layout_compatible(layout):
		return grid.layout_error_message(layout)
	return ""
