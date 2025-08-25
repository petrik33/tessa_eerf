@tool
class_name HexagonalHexGrid extends HexGridBase

@export var radius := 6:
	set(value):
		radius = max(0, value)
		emit_changed()
		
func _init(_radius: int = 0):
	radius = _radius

func iterator() -> HexGridIteratorBase:
	return SpiralHexGridIterator.new(radius)

func has_point(hex: Vector2i) -> bool:
	return HexMath.is_in_radius(hex, radius)
	
func approx_pixel_bounds(layout: HexLayout) -> Rect2:
	var bounds := layout.hex_pixel_bounds()
	var corners := [
		Vector2i(-radius, radius), Vector2i(radius, -radius),
		Vector2i(radius, 0), Vector2i(0, radius),
		Vector2i(-radius, 0), Vector2i(0, -radius)
	]
	for corner in corners:
		bounds = bounds.expand(layout.hex_to_pixel(corner))
	return bounds

func is_layout_compatible(_layout: HexLayout) -> bool:
	return true # compatible with any axial layout

func layout_error_message(_layout: HexLayout) -> String:
	return ""
