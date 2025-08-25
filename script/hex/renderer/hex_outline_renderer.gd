@tool
@icon("res://editor/icons/hex_outline_renderer.svg")
class_name HexOutlineRenderer extends HexGridRendererBase

@export var outline_color := Color.BLACK:
	set(new_color):
		outline_color = new_color
		queue_redraw()
		
@export var outline_width: float = 0.5:
	set(new_width):
		outline_width = new_width
		queue_redraw()
		
@export var antialiased := true:
	set(value):
		antialiased = value
		queue_redraw()

func _draw_impl(grid: HexGridBase, layout: HexLayout):
	for hex in grid.iterator():
		_draw_hex_outline(layout, hex)

func _draw_hex_outline(layout: HexLayout, hex: Vector2i):
	var hex_offset := layout.hex_to_pixel(hex)
	draw_polyline(layout.hex_polygon(hex_offset), 
		outline_color, outline_width, antialiased
	)
