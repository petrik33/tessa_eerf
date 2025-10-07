@tool
class_name CombatUiUnitsLeftMarker extends Control


@export var army_colors: Dictionary[String, Color]:
	set(value):
		army_colors = value
		queue_redraw()
		update_configuration_warnings()

@export var default_color: Color:
	set(value):
		default_color = value
		if army_id == "":
			queue_redraw()

@export var hex_layout: HexLayout:
	set(value):
		if hex_layout != null:
			hex_layout.changed.disconnect(_update)
		hex_layout = value
		if hex_layout != null:
			hex_layout.changed.connect(_update)
		_update()

@export var next_turn_progress := 1.0:
	set(value):
		next_turn_progress = value
		queue_redraw()

@export var army_id: String:
	set(value):
		army_id = value
		queue_redraw()

@export var next_turn_progress_corner_idx_offset := 1:
	set(value):
		next_turn_progress_corner_idx_offset = value
		queue_redraw()

@export var inverse_turn_progress_fill := true:
	set(value):
		inverse_turn_progress_fill = value
		queue_redraw()

@onready var label: Label = %Label


func set_stack_size(count: int):
	label.text = "%d" % [count]


func _draw() -> void:
	if hex_layout == null:
		return
	var color := default_color
	if army_id != "":
		assert(army_colors.has(army_id), "No army color exists in marker for id %s" % [army_id])
		color = army_colors[army_id]
	_draw_hex_progress(hex_layout, next_turn_progress, color)


func _get_configuration_warnings() -> PackedStringArray:
	if hex_layout == null:
		return ["Hex layout not set"]
	if army_colors.is_empty():
		return ["Team colors not set"]
	return []


func _update():
	queue_redraw()
	update_configuration_warnings()


func _draw_hex_progress(layout: HexLayout, progress: float, fill_color: Color, background_color: Color = Color.TRANSPARENT) -> void:
	if background_color != Color.TRANSPARENT:
		draw_polygon(layout.hex_polygon(), [background_color])
	if progress <= 0.0:
		return
	if progress >= 1.0:
		draw_polygon(layout.hex_polygon(), [fill_color])
		return
	
	var polygon := PackedVector2Array()
	
	var corner_offset := next_turn_progress_corner_idx_offset % HexLayoutMath.CORNER_NUM
	
	var radial_angle := progress * PI * 2
	var radial_progress := radial_angle / HexLayoutMath.HEX_ANGLE_STEP
	var corner_radial_progress = floor(radial_progress)
	var segments_filled := (int(corner_radial_progress) % HexLayoutMath.CORNER_NUM) 
	
	for idx in range(segments_filled + 1):
		var corner_idx := corner_offset - idx if inverse_turn_progress_fill else corner_offset + idx
		polygon.append(layout.hex_corner(corner_idx))
	
	var last_corner_idx := corner_offset - segments_filled if inverse_turn_progress_fill else corner_offset + segments_filled
	var next_corner_idx := last_corner_idx -1 if inverse_turn_progress_fill else last_corner_idx + 1
	var line_progress = radial_progress - corner_radial_progress
	
	polygon.append(lerp(layout.hex_corner(last_corner_idx), layout.hex_corner(next_corner_idx), line_progress))
	polygon.append(Vector2.ZERO)
	polygon.append(hex_layout.hex_corner(corner_offset))
	
	draw_polygon(polygon, [fill_color])	
