class_name PixelArt3dSpaceBridge extends Node


@export var camera: Camera3D


func project_to_ground_plane(camera_space_point: Vector2) -> Vector3:
	var ray_origin = camera.project_ray_origin(camera_space_point)
	var ray_direction = camera.project_ray_normal(camera_space_point)
	
	if abs(ray_direction.y) < 0.0001:
		return Vector3.ZERO
	
	var t = -ray_origin.y / ray_direction.y
	
	var ground_point = ray_origin + t * ray_direction
	ground_point.y = 0.0
	
	return ground_point
