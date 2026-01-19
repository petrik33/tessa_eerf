extends Node


@export var camera: Camera2D
@export var edge_margin := 6.0
@export var scroll_initial_speed := 150.0
@export var scroll_acceleration := 200.0
@export var max_scroll_speed := 1000.0


var scroll_dir := Vector2.ZERO
var scroll_speed := 0.0


func _ready() -> void:
	set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var dir := _calc_scroll_direction(event.position)
		if scroll_dir.is_equal_approx(dir):
			return
		if dir.is_equal_approx(Vector2.ZERO):
			scroll_dir = Vector2.ZERO
			scroll_speed = 0
			set_process(false)
		else:
			scroll_dir = dir
			if scroll_speed < scroll_initial_speed:
				scroll_speed = scroll_initial_speed
			set_process(true)


func _process(delta: float) -> void:
	var previous_cam_position := camera.position
	camera.position = _calc_camera_position(delta)
	if previous_cam_position.is_equal_approx(camera.position):
		scroll_speed = 0
	else:
		scroll_speed = min(scroll_speed + delta * scroll_acceleration, max_scroll_speed)


func _calc_camera_position(delta: float) -> Vector2:
	var new_pos := camera.position + scroll_dir * scroll_speed * delta

	var half_view := get_viewport().get_visible_rect().size * 0.5 * camera.zoom

	new_pos.x = clamp(new_pos.x,
		camera.limit_left + half_view.x,
		camera.limit_right - half_view.x
	)

	new_pos.y = clamp(new_pos.y,
		camera.limit_top + half_view.y,
		camera.limit_bottom - half_view.y
	)
	
	return new_pos


func _calc_scroll_direction(pos: Vector2) -> Vector2:
	var size = get_viewport().get_visible_rect().size
	var dir := Vector2.ZERO
	
	if pos.x < edge_margin:
		dir.x = -1
	elif pos.x > size.x - edge_margin:
		dir.x = 1
	
	if pos.y < edge_margin:
		dir.y = -1
	elif pos.y > size.y - edge_margin:
		dir.y = 1
	
	return dir
