@tool
class_name teCombatUnitEffectStatus extends Control


@export var effect_ticks: Array[int]
@export var tick_width: float = 2.0
@export var offset: float = 0.0
@export var segment_height: float = 1.0
@export var segment_color: Color


func _draw():
	for ticks in effect_ticks:
		var segment_width := tick_width * ticks
		var segment_rect := Rect2(Vector2(offset, 0.0), Vector2(segment_width, segment_height))
		draw_rect(segment_rect, segment_color)
