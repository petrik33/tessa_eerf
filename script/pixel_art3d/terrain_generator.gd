@tool
class_name PixelArt3dTerrainGenerator extends Node


@export var hex_space : HexSpace
@export var grid : HexGridBase
@export var board_projection: PixelArt3dBoardProjection


@export var grass_mesh : Mesh
@export var grass_material : Material
@export var grass_density = 40

@export var terrain_material : Material
@export var terrain_height = 0.15
@export var border_width = 0.06

@export var debug_container: Node3D


@export_tool_button("Generate")
var generate_button = generate_terrain


func _ready() -> void:
	generate_terrain()


func generate_terrain():
	_clear()

	for hex in grid.iterator():
		_spawn_debug_capsule(hex) 


func _spawn_debug_capsule(hex: Vector2i):
	var pixel_pos = hex_space.layout.hex_to_pixel(hex) + hex_space.position
	var world_pos = board_projection.pixel_to_world(pixel_pos)

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = _create_capsule_mesh()
	mesh_instance.material_override = grass_material

	mesh_instance.position = world_pos
	debug_container.add_child(mesh_instance)

func _create_capsule_mesh() -> Mesh:
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.1
	capsule.height = 3
	capsule.radial_segments = 8
	capsule.rings = 4
	return capsule

func _clear():
	for node in debug_container.get_children():
		debug_container.remove_child(node)
		node.queue_free()
