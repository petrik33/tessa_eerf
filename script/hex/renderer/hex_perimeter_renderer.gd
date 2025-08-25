@tool
@icon("res://editor/icons/hex_perimeter_renderer.svg")
class_name HexPerimeterRenderer extends HexGridRendererBase

@export var color := Color.WHITE:
	set(new_color):
		color = new_color
		queue_redraw()
		
@export var width: float = 1.0:
	set(new_width):
		width = new_width
		queue_redraw()
		
@export var antialiased := true:
	set(value):
		antialiased = value
		queue_redraw()

func _draw_impl(grid: HexGridBase, layout: HexLayout):
	for hex in grid.iterator():
		_draw_hex_perimeter_outline(grid, layout, hex)
	
func _draw_hex_perimeter_outline(grid: HexGridBase, layout: HexLayout, hex: Vector2i):
	var hex_pos = layout.hex_to_pixel(hex)
	for dir in range(HexLayoutMath.CORNER_NUM):
		var neighbor := HexMath.neighbor(hex, dir)
		if not grid.has_point(neighbor):
			var a = layout.hex_corner(dir)
			var b = layout.hex_corner((dir + 5) % 6)
			draw_line(hex_pos + a, hex_pos + b, color, width, antialiased)
