@tool
class_name CombatUiUnitMarker extends Control


@export var army_colors: Dictionary[String, Color]:
	set(value):
		army_colors = value
		queue_redraw()
		update_configuration_warnings()

@export var bg_color: Color:
	set(value):
		bg_color = value
		queue_redraw()

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

@export_range(0.0, 1.0, 0.01) var fill_percentage := 0.75:
	set(value):
		fill_percentage = value
		queue_redraw()

@export var fill_gradient: Gradient:
	set(value):
		if fill_gradient != null:
			fill_gradient.changed.disconnect(_update)
		fill_gradient = value
		if fill_gradient != null:
			fill_gradient.changed.connect(_update)
		_update()

@export var outline_width := 1.0:
	set(value):
		outline_width = value
		queue_redraw()

@export var army_id: String:
	set(value):
		army_id = value
		queue_redraw()


@onready var label: Label = %Label


func set_stack_size(count: int):
	label.text = "%d" % [count]


func _draw() -> void:
	if hex_layout == null or fill_gradient == null:
		return
	var outline_color := default_color
	if army_id != "":
		assert(army_colors.has(army_id), "No army color exists in marker for id %s" % [army_id])
		outline_color = army_colors[army_id]
	var hex := hex_layout.hex_polygon()
	draw_polygon(hex, [bg_color])
	var health_polygon := Math.clip_polygon_bottom_percent_halfplane(hex, fill_percentage)
	var health_color := fill_gradient.sample(fill_percentage)
	draw_polygon(health_polygon, [health_color])
	draw_polyline(hex, outline_color, outline_width)


func _get_configuration_warnings() -> PackedStringArray:
	if hex_layout == null:
		return ["Hex layout not set"]
	if army_colors.is_empty():
		return ["Team colors not set"]
	if fill_gradient == null:
		return ["Fill gradient not set"]
	return []


func _update():
	queue_redraw()
	update_configuration_warnings()
