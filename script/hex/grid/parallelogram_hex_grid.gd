@tool
class_name ParallelogramHexGrid extends HexGridBase


@export var axis_pair: HexMath.AxisPair = HexMath.AxisPair.QR:
	set(value):
		axis_pair = value
		emit_changed()

@export var origin: Vector2i = Vector2i.ZERO:
	set(value):
		origin = value
		emit_changed()

@export var size: Vector2i = Vector2i(10, 10):
	set(value):
		size = value
		emit_changed()


func iterator() -> HexGridIteratorBase:
	return ParallelogramHexGridIterator.new(origin, size, axis_pair)


func has_point(hex: Vector2i) -> bool:
	var ab = HexMath.to_ab(hex, axis_pair)
	var ab_origin = HexMath.to_ab(origin, axis_pair)
	var ab_bounds := Rect2i(ab_origin, size)
	return ab_bounds.has_point(ab)


func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var pixel_bounds := Rect2(layout.hex_to_pixel(origin), Vector2.ZERO)
	var ab_origin = HexMath.to_ab(origin, axis_pair)
	
	var cornerns = [
		origin,
		HexMath.from_ab(ab_origin + Vector2i(size.x, 0), axis_pair),
		HexMath.from_ab(ab_origin + Vector2i(0, size.y), axis_pair),
		HexMath.from_ab(ab_origin + size, axis_pair),
	]

	for hex in cornerns:
		pixel_bounds = pixel_bounds.expand(layout.hex_to_pixel(hex))

	return pixel_bounds


func is_layout_compatible(_layout: HexLayout) -> bool:
	return true


func layout_error_message(_layout: HexLayout) -> String:
	return ""
