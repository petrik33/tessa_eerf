@tool
class_name PixelArt3dBoardProjection extends Node


@export var viewport: SubViewport
@export var camera_rig: PixelArt3dCameraRig


func _ready() -> void:
	_update_transforms()


func pixel_to_world(pixel: Vector2) -> Vector3:
	var ndc = pixel - _vp_center

	return Vector3(
		ndc.x * _pixel_to_world.x,
		0.0,
		ndc.y * _pixel_to_world.z
	)


func world_to_pixel(world: Vector3) -> Vector2:
	var ndc = Vector2(
		world.x * _world_to_pixel.x,
		world.z * _world_to_pixel.z
	)

	return ndc + _vp_center


var _vp_size: Vector2
var _vp_center: Vector2

var _pixel_to_world: Vector3
var _world_to_pixel: Vector3


func _update_transforms():
	_vp_size = viewport.get_visible_rect().size
	_vp_center = _vp_size * 0.5

	var aspect = _vp_size.x / _vp_size.y

	var pitch = camera_rig.get_pitch()
	var camera_size = camera_rig.get_size()
	var sin_pitch = sin(pitch)

	_pixel_to_world = Vector3(
		camera_size * aspect / _vp_center.x,
		0.0,
		camera_size / (sin_pitch * _vp_center.y)
	)

	_world_to_pixel = Vector3(
		1.0 / _pixel_to_world.x,
		0.0,
		1.0 / _pixel_to_world.z
	)
