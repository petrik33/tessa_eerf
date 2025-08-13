@tool
class_name HexCoordinatesDrawer extends HexDrawerBase
		
@export var use_cube_format := true:
	set(value):
		use_cube_format = value
		queue_redraw()
		
@export var font := ThemeDB.fallback_font:
	set(value):
		font = value
		queue_redraw()
		
@export var font_size := 10:
	set(value):
		font_size = value
		queue_redraw()

func _draw_impl():
	for hex in grid.iterator():
		_draw_hex_coordinates(hex)

func _draw_hex_coordinates(hex: Vector2i):
	var offset := layout.hex_to_pixel(hex)
	var format := HexUtils.cube_format(hex) if use_cube_format else HexUtils.axial_format(hex)
	var pos := offset - Vector2(layout.size, - font_size / 2)
	var width := layout.size * 2
	draw_string(font, pos, format, HORIZONTAL_ALIGNMENT_CENTER, width, font_size)
