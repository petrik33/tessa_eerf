@tool
class_name FocusOverlay extends ColorRect


@export var radius: float = 72.0:
	set(value):
		radius = value
		_update_shader()

@export var softness: float = 18.0:
	set(value):
		softness = value
		_update_shader()

@export var targets: Array[Vector2] = []:
	set(value):
		targets = value
		_update_shader()


func _ready():
	_update_shader()


func _update_shader():
	if material == null:
		return
	
	var world_to_overlay_space_transform := get_global_transform()
	var focus_points := PackedVector2Array()

	for world_p in targets:
		focus_points.append(world_p * world_to_overlay_space_transform)

	material.set_shader_parameter("focus_points", PackedVector2Array(focus_points))
	material.set_shader_parameter("focus_count", focus_points.size())

	material.set_shader_parameter("radius", radius)
	material.set_shader_parameter("softness", softness)


func _get_configuration_warnings() -> PackedStringArray:
	if material == null:
		return ["Overlay material not set"]
	return []
