@tool
class_name RowLengthHexGrid extends HexGridBase

@export var row_lengths: Array[int]:
	set(value):
		row_lengths = value
		emit_changed()

@export var row_offsets: Array[int]:
	set(value):
		row_offsets = value
		emit_changed()

@export var offset_hex_math: OffsetHexMathBase:
	set(value):
		if offset_hex_math != null:
			offset_hex_math.changed.disconnect(emit_changed)
		offset_hex_math = value
		if offset_hex_math != null:
			offset_hex_math.changed.connect(emit_changed)
		emit_changed()

func iterator() -> HexGridIteratorBase:
	return RowLengthHexGridIterator.new(row_lengths, row_offsets, offset_hex_math)

func has_point(hex: Vector2i) -> bool:
	var offset = offset_hex_math.from_axial(hex)
	var row = offset.y
	if row < 0 or row >= row_lengths.size():
		return false
	var start_col = row_offsets[row]
	var end_col = start_col + row_lengths[row] - 1
	return offset.x >= start_col and offset.x <= end_col

func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	return exact_pixel_bounds(layout)

func is_layout_compatible(layout: HexLayout) -> bool:
	return offset_hex_math != null and offset_hex_math.is_layout_compatible(layout)

func layout_error_message(layout: HexLayout) -> String:
	return offset_hex_math.layout_error_message(layout) if offset_hex_math != null else "Offset hex math not set"
