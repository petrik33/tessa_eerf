@tool
@icon("res://editor/icons/hex_filled_renderer_editor_icon.svg")
class_name HexFilledRenderer extends HexMapRendererBase

@export var hex_color := Color.WHITE:
	set(new_color):
		hex_color = new_color
		queue_redraw()

func _draw_impl(grid: HexGridBase, layout: HexLayout):
	for hex in grid.iterator():
		_draw_hex(layout, hex)

func _draw_hex(layout: HexLayout, hex: Vector2i):
	var hex_offset := layout.hex_to_pixel(hex)
	var hex_transform := Transform2D(0, hex_offset)
	draw_mesh(layout.hex_mesh(), null, hex_transform, hex_color)
