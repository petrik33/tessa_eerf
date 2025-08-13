@tool
@icon("res://editor/icons/hex_outline_drawer_editor_icon.svg")
class_name HexOutlineDrawer extends HexDrawerBase

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

func _draw_impl():
	for hex in grid.iterator():
		_draw_hex_outline(hex)

func _draw_hex_outline(hex: Vector2i):
	var hex_offset := layout.hex_to_pixel(hex)
	draw_polyline(layout.hex_polygon(hex_offset), 
		outline_color, outline_width, antialiased
	)
