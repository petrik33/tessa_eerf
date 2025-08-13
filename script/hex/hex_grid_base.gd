@tool
class_name HexGridBase extends Resource

func iterator() -> HexGridIteratorBase:
	assert(false, "not implemented")
	return null

func has_point(_hex: Vector2i) -> bool:
	assert(false, "not implemented")
	return false
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	assert(false, "not implemented")
	return Rect2(Vector2.ZERO, Vector2.ZERO)
	
func exact_pixel_bounds(layout: HexLayout) -> Rect2:
	# @TODO Optimize by iterating over perimeter
	var it := iterator()
	var gridIsNotEmpty = it._iter_init(null)
	assert(gridIsNotEmpty, "Grid must be not empty to have exact pixel bounds")
	var hex := it._iter_get(null)
	var bounds := layout.hex_pixel_bounds(hex)
	while it._iter_next(null):
		hex = it._iter_get(null)
		bounds.merge(layout.hex_pixel_bounds(hex))
	return bounds

func is_layout_compatible(layout: HexLayout) -> bool:
	assert(false, "not implemented")
	return false

func layout_error_message(layout: HexLayout) -> String:
	return "This layout is not compatible with this hex grid."
