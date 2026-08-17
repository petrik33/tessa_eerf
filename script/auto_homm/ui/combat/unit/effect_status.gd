@tool
class_name teCombatUnitEffectStatus extends Control


@export var segments: Dictionary[int, teCombatUnitEffectSegment] = {}:
	set(value):
		segments = value
		queue_redraw()

@export var tick_width: float = 2.0:
	set(value):
		tick_width = value
		queue_redraw()

@export var segment_height: float = 1.0:
	set(value):
		segment_height = value
		queue_redraw()

@export var segment_color: Color:
	set(value):
		segment_color = value
		queue_redraw()

@export var flash_value: float = 0.0:
	set(value):
		flash_value = value
		if material != null and material is ShaderMaterial:
			material.set_shader_parameter("flash_strength", flash_value)
		queue_redraw()


func get_segment_width(id: int) -> float:
	return segments[id].ticks * tick_width


func flash():
	if _flash_tween:
		_flash_tween.kill()

	flash_value = 1.0

	_flash_tween = create_tween()
	_flash_tween.tween_property(
		self,
		"flash_value",
		0.0,
		0.35
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


var _flash_tween: Tween


func _draw():
	if flash_value > 0.0:
		draw_rect(Rect2(position,size), segment_color)
		return
	
	for id in segments:
		var segment := segments[id]
		var width = get_segment_width(id)
		var offset = segment.offset

		draw_rect(
			Rect2(
				Vector2(offset, 0.0),
				Vector2(width, segment_height)
			),
			segment_color
		)
