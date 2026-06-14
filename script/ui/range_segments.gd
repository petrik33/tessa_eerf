@tool
class_name RangeSegments extends Range


@export var segment_value: float = 300.0:
	set(value):
		segment_value = value
		queue_redraw()
	
@export var segment_color: Color = Color(0, 0, 0, 0.7):
	set(value):
		segment_color = value
		queue_redraw()
	
@export var segment_width: float = 1.0:
	set(value):
		segment_width = value
		queue_redraw()
	
@export var clip_to_value: bool = true:
	set(value):
		clip_to_value = value
		queue_redraw()


func _value_changed(_value: float) -> void:
	queue_redraw()


func _draw():
	var rect := Rect2(Vector2.ZERO, size)

	if max_value <= 0:
		return

	var fill_ratio := value / max_value
	var fill_width := rect.size.x * fill_ratio

	if clip_to_value:
		draw_segments(rect, fill_width)
	else:
		draw_segments(rect, rect.size.x)


func draw_segments(rect: Rect2, limit_x: float):
	if segment_value <= 0:
		return

	var segment_count := int(floor(max_value / segment_value))
	if segment_count <= 0:
		return

	for i in range(1, segment_count):
		var value_at_segment := i * segment_value
		var t := value_at_segment / max_value
		var x := rect.size.x * t
		if x >= limit_x:
			break
		var line_rect := Rect2(
			Vector2(x - segment_width * 0.5, 0.0),
			Vector2(segment_width, size.y)
		)

		draw_rect(line_rect, segment_color)
