@tool
@icon("res://editor/icons/hex_filled_renderer.svg")
class_name HexFilledRenderer extends HexGridRendererBase

@export var hex_color := Color.WHITE:
	set(new_color):
		hex_color = new_color
		queue_redraw()

func _draw_impl(grid: HexGridBase, layout: HexLayout):
	for hex in grid.iterator():
		_draw_hex(layout, hex)

func _draw_hex(layout: HexLayout, hex: Vector2i):
	var hex_offset := layout.hex_to_pixel(hex)
	draw_polygon(layout.hex_polygon(hex_offset), [hex_color])
