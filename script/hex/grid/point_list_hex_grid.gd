@tool
class_name PointListHexGrid extends HexGridBase

@export var points: Array[Vector2i] = []:
	set(value):
		points = value
		emit_changed()

func iterator() -> HexGridIteratorBase:
	return PointListHexGridIterator.new(points)

func has_point(hex: Vector2i) -> bool:
	return points.has(hex)
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	if points.is_empty():
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	
	var bounds := Rect2(Vector2.ZERO, Vector2.ZERO)
	for hex in points:
		bounds = bounds.expand(layout.hex_to_pixel(hex))
	return bounds

func pivot_point() -> Vector2i:
	if points.is_empty():
		return Vector2i.ZERO
	
	var min_hex := points[0]
	var max_hex := points[0]
	
	for hex in points:
		min_hex = Vector2i(min(min_hex.x, hex.x), min(min_hex.y, hex.y))
		max_hex = Vector2i(max(max_hex.x, hex.x), max(max_hex.y, hex.y))
	
	return (min_hex + max_hex) / 2

func is_layout_compatible(_layout: HexLayout) -> bool:
	return true  # Compatible with any layout

func layout_error_message(_layout: HexLayout) -> String:
	return ""
