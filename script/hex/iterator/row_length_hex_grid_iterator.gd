@tool
class_name RowLengthHexGridIterator extends HexGridIteratorBase

var row_lengths: Array[int]
var row_offsets: Array[int]
var offset_hex_math: OffsetHexMathRes
var current_row := 0
var current_col := 0

func _init(_row_lengths, _row_offsets, _offset_hex_math):
	row_lengths = _row_lengths
	row_offsets = _row_offsets
	offset_hex_math = _offset_hex_math

func _iter_init(_arg) -> bool:
	current_row = 0
	current_col = 0
	return row_lengths.size() > 0

func _iter_next(_arg) -> bool:
	current_col += 1
	if current_col >= row_lengths[current_row]:
		current_row += 1
		current_col = 0
	return current_row < row_lengths.size()

func _iter_get(_arg):
	var offset = Vector2i(row_offsets[current_row] + current_col, current_row)
	return offset_hex_math.to_axial(offset)
