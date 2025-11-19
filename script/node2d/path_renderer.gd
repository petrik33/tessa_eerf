@tool
class_name PathRenderer extends Node2D


@export var path: Array[Vector2]:
	set(value):
		path = value
		queue_redraw()


@export var width: float = 1.0:
	set(value):
		width = value
		queue_redraw()


@export var color: Color = Color(0.2, 0.8, 1.0):
	set(value):
		color = value
		queue_redraw()


@export var circle_radius := 4.0:
	set(value):
		circle_radius = value
		queue_redraw()


@export var antialised := true:
	set(value):
		antialised = value
		queue_redraw()


func _draw():
	if path.size() < 2:
		return
	draw_polyline(PackedVector2Array(path), color, width, antialised)
	draw_circle(path.back(), circle_radius, color, true, -1.0, antialised)
