class_name HexPicking extends Node


signal hovered(hex: Vector2i, previous: Vector2i)
signal entered_grid(hex: Vector2i)
signal left_grid(last_hex: Vector2i)
signal clicked(hex: Vector2i, event: InputEventMouseButton)


@export var space: HexSpace:
	set(value):
		space = value
		update_configuration_warnings()

@export var grid: HexGridBase:
	set(value):
		grid = value
		update_configuration_warnings()


var current_hex: Vector2i


func _ready() -> void:
	if not _get_configuration_warnings().is_empty():
		set_process_unhandled_input(false)
		return
	current_hex = space.layout.pixel_to_hex(
		space.to_local(get_viewport().get_mouse_position())
	)


func _get_configuration_warnings() -> PackedStringArray:
	if grid == null:
		return ["Hex grid not assigned"]
	if space == null:
		return ["Hex space not assigned"]
	if not space.is_configured():
		return ["Hex Space not configured"]
	if not grid.is_layout_compatible(space.layout):
		return [grid.layout_error_message(space.layout)]
	return []


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var hex = space.layout.pixel_to_hex(space.to_local(event.position))
		
		if current_hex == hex:
			return
			
		if grid.has_point(hex):
			if not grid.has_point(current_hex):
				entered_grid.emit(hex)
			hovered.emit(hex, current_hex)
		else:
			if grid.has_point(current_hex):
				left_grid.emit(current_hex)
		
		current_hex = hex
	
	if event is InputEventMouseButton:
		if event.pressed and grid.has_point(current_hex):
			clicked.emit(current_hex, event)
