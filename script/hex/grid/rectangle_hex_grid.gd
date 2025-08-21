@tool
class_name RectangleHexGrid extends HexGridBase

@export var bounds := Rect2i(0, 0, 10, 10):
	set(value):
		bounds = value
		emit_changed()

@export var offset_hex_math: OffsetHexMathRes:
	set(value):
		if offset_hex_math != null:
			offset_hex_math.changed.disconnect(emit_changed)
		offset_hex_math = value
		if offset_hex_math != null:
			offset_hex_math.changed.connect(emit_changed)
		emit_changed()

func iterator() -> HexGridIteratorBase:
	return RectangleHexGridIterator.new(bounds, offset_hex_math)

func has_point(hex: Vector2i) -> bool:
	return bounds.has_point(offset_hex_math.from_axial(hex))
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var left_top = offset_hex_math.to_axial(bounds.position)
	var right_bottom = offset_hex_math.to_axial(bounds.position + bounds.size - Vector2i.ONE)
	return Rect2(layout.hex_to_pixel(left_top), layout.hex_to_pixel(right_bottom))

func pivot_point() -> Vector2i:
	return bounds.position

func is_layout_compatible(layout: HexLayout) -> bool:
	return offset_hex_math != null and offset_hex_math.is_layout_compatible(layout)

func layout_error_message(layout: HexLayout) -> String:
	return offset_hex_math.layout_error_message(layout) if offset_hex_math != null else "Offset hex math not set"
