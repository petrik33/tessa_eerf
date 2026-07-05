@tool
class_name PixelArt3dCameraRig extends Node3D

@export var orbit_point: Vector3 = Vector3.ZERO:
	set(value):
		orbit_point = value
		global_position = orbit_point

@export var yaw_speed := 90.0
@export var pitch_speed := 60.0
@export var zoom_speed := 8.0

@export var min_pitch := -80.0
@export var max_pitch := -20.0

@export var min_zoom := 3.0
@export var max_zoom := 20.0

@export var yaw: Node3D
@export var pitch: Node3D
@export var camera: Camera3D

var zoom := 20.0

func _ready():
	global_position = orbit_point
	zoom = camera.position.z


func _process(delta):
	if Engine.is_editor_hint():
		return
	
	global_position = orbit_point

	if Input.is_action_pressed("camera_right"):
		yaw.rotate_y(deg_to_rad(yaw_speed * delta))

	if Input.is_action_pressed("camera_left"):
		yaw.rotate_y(deg_to_rad(-yaw_speed * delta))

	var pitch_delta := 0.0

	if Input.is_action_pressed("camera_down"):
		pitch_delta += pitch_speed * delta

	if Input.is_action_pressed("camera_up"):
		pitch_delta -= pitch_speed * delta

	var x := pitch.rotation_degrees.x + pitch_delta
	x = clamp(x, min_pitch, max_pitch)
	pitch.rotation_degrees.x = x

	if Input.is_action_pressed("camera_zoom_in"):
		zoom -= zoom_speed * delta

	if Input.is_action_pressed("camera_zoom_out"):
		zoom += zoom_speed * delta

	zoom = clamp(zoom, min_zoom, max_zoom)
	camera.position.z = zoom


func get_pitch() -> float:
	return -pitch.rotation.x

func get_size() -> float:
	return camera.size
