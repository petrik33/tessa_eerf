class_name PixelArt3dGrass extends Node

@export var wind: PixelArt3dWind:
	set(value):
		if wind != value:
			if wind != null:
				_disconnect_wind_signals()
			wind = value
			if wind != null:
				_connect_wind_signals()
				_update_grass_from_wind()

@export var grass_blades: MultiMeshInstance3D:
	set(value):
		grass_blades = value
		if grass_blades:
			_initialize_grass_blades_shader_parameters()

@export var grass_plane: MeshInstance3D:
	set(value):
		grass_plane = value
		if grass_plane:
			_initialize_grass_plane_shader_parameters()

@export var wind_noise: NoiseTexture2D:
	set(value):
		wind_noise = value
		_update_fast_noise()

@export var wind_debug: MeshInstance3D

@export var board_texture_renderer: PixelArt3dBoardTextureRenderer

@export var min_sway_angle: float = 5.0
@export var max_sway_angle: float = 45.0

var _blades_shader_material: ShaderMaterial
var _plane_shader_material: ShaderMaterial
var _wind_noise_lite: FastNoiseLite
var _board_texture: Texture
var _cached_direction: Vector2 = Vector2.ZERO
var _cached_noise_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	_initialize_grass_plane_shader_parameters()
	_initialize_grass_blades_shader_parameters()
	_update_grass_from_wind()
	if board_texture_renderer:
		board_texture_renderer.updated.connect(_update_board_texture)
		_update_board_texture(board_texture_renderer.get_texture())


func _exit_tree() -> void:
	if board_texture_renderer:
		board_texture_renderer.updated.disconnect(_update_board_texture)
	if wind:
		_disconnect_wind_signals()


func force_update() -> void:
	_update_grass_from_wind()


func _initialize_grass_blades_shader_parameters() -> void:
	if not grass_blades:
		return
	
	var multimesh := grass_blades.multimesh
	if not multimesh:
		return
	
	var mesh := multimesh.mesh as QuadMesh;
	if not mesh:
		return
	
	var material := mesh.material;
	if material and material is ShaderMaterial:
		_blades_shader_material = material


func _initialize_grass_plane_shader_parameters() -> void:
	if not grass_plane:
		return
	
	var material := grass_plane.get_surface_override_material(0);
	if material and material is ShaderMaterial:
		_plane_shader_material = material


func _update_fast_noise() -> void:
	if wind_noise == null:
		_wind_noise_lite = null
		return
	if wind_noise.noise == null:
		_wind_noise_lite = null
		return
	_wind_noise_lite = wind_noise.noise as FastNoiseLite


func _connect_wind_signals() -> void:
	wind.updated.connect(_on_wind_updated)
	wind.direction_changed.connect(_on_wind_direction_changed)
	wind.speed_changed.connect(_on_wind_speed_changed)


func _disconnect_wind_signals() -> void:
	wind.updated.disconnect(_on_wind_updated)
	wind.direction_changed.disconnect(_on_wind_direction_changed)
	wind.speed_changed.disconnect(_on_wind_speed_changed)



func _update_board_texture(texture: ViewportTexture) -> void:
	var board_texture_image = texture.get_image()
	_board_texture = ImageTexture.create_from_image(board_texture_image)
	if _plane_shader_material:
		_plane_shader_material.set_shader_parameter("terrain_texture", _board_texture)


func _on_wind_updated(noise_offset: Vector2) -> void:
	_update_wind_noise_offset(noise_offset)


func _on_wind_direction_changed(new_direction: Vector2) -> void:
	_update_wind_direction(new_direction)


func _on_wind_speed_changed(new_speed: float) -> void:
	_update_sway(new_speed)


func _update_grass_from_wind() -> void:
	if not _blades_shader_material or not _plane_shader_material:
		return
	
	_update_wind_direction(wind.get_direction_vector())
	_update_sway(wind.speed * wind.magnitude)
	_update_wind_noise_offset(wind.offset)


func _update_wind_direction(direction: Vector2) -> void:
	if not _blades_shader_material or not _plane_shader_material:
		return
	
	_cached_direction = direction
	_update_wind_debug(direction)
	_blades_shader_material.set_shader_parameter("wind_direction", direction)
	_plane_shader_material.set_shader_parameter("wind_direction", direction)


func _update_sway(speed: float) -> void:
	if not _blades_shader_material or not _plane_shader_material:
		return
	
	var sway = min_sway_angle + (max_sway_angle - min_sway_angle) * clamp(speed / 2.0, 0.0, 1.0)
	_blades_shader_material.set_shader_parameter("sway_angle", sway)
	_plane_shader_material.set_shader_parameter("sway_angle", sway)


func _update_wind_noise_offset(offset: Vector2) -> void:
	_cached_noise_offset = offset
	_wind_noise_lite.offset = Vector3(offset.x, offset.y, 0.0);


func _update_wind_debug(wind_direction: Vector2):
	wind_debug.rotate(Vector3.UP, wind_direction.angle())


func get_shader_info() -> Dictionary:
	if not _blades_shader_material:
		return {"error": "No shader material available"}
	
	var info = {
		"material": _blades_shader_material.resource_name if _blades_shader_material.resource_name else "Unnamed",
		"wind_direction": _blades_shader_material.get_shader_parameter("wind_direction"),
		"sway_angle": _blades_shader_material.get_shader_parameter("sway_angle"),
		"wind_noise_offset": _blades_shader_material.get_shader_parameter("wind_noise_offset")
	}
	return info
