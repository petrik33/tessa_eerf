@tool
class_name PixelArt3dTerrainGenerator extends Node


@export_tool_button("Generate")
var generate_button = generate

@export_tool_button("Clear")
var clear_generation = clear


@export var hex_space : HexSpace
@export var grid : HexGridBase
@export var board_projection: PixelArt3dBoardProjection

@export var grass_mesh : Mesh
@export var grass_density := 40
@export var grass_terrain_scale := 0.95

@export var plane_scale := 1.2
@export var plane_material : Material

@export var terrain_material : Material
@export var terrain_height := 0.15
@export var hex_scale := 0.95

@export var heroes_node: Node2D
@export var heroes_terrain_layout: HexLayout
@export var heroes_terrain_material: Material
@export var heroes_terrain_y_offset := 4
@export var heroes_terrain_height := 0.15

@export var rng_seed: int = 42
@export var container: Node3D


func generate():
	clear()
	_rng.seed = rng_seed
	board_projection.update()
	_generate_base_plane()
	_generate_terrain()
	_generate_hero_stands()
	_generate_grass()


func clear():
	for node in container.get_children():
		container.remove_child(node)
		node.queue_free()
	
	_terrain_hex_grid = null
	_base_plane = null
	_grass = null
	_hero_stands = null


var _terrain_hex_grid: MeshInstance3D
var _base_plane: MeshInstance3D
var _grass: MultiMeshInstance3D
var _hero_stands: MeshInstance3D
var _rng := RandomNumberGenerator.new()


func _generate_terrain():
	_terrain_hex_grid = MeshInstance3D.new()
	_terrain_hex_grid.mesh = _build_terrain_mesh()
	_terrain_hex_grid.material_override = terrain_material
	_terrain_hex_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	container.add_child(_terrain_hex_grid)
	_try_make_editor_owned(_terrain_hex_grid)


func _generate_base_plane():
	_base_plane = MeshInstance3D.new()
	_base_plane.mesh = _create_base_plane_mesh()
	_base_plane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_base_plane.set_surface_override_material(0, plane_material)
	_base_plane.position.y = -terrain_height
	container.add_child(_base_plane)
	_try_make_editor_owned(_base_plane)


func _generate_grass():
	_grass = MultiMeshInstance3D.new()
	_grass.multimesh = _collect_grass_multimesh()
	_grass.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	container.add_child(_grass)
	_try_make_editor_owned(_grass)


func _generate_hero_stands():
	_hero_stands = MeshInstance3D.new()
	_hero_stands.mesh = _build_hero_stands_mesh()
	_hero_stands.set_surface_override_material(0, heroes_terrain_material)
	_hero_stands.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	container.add_child(_hero_stands)
	_try_make_editor_owned(_hero_stands)


func _build_hero_stands_mesh() -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for node in heroes_node.get_children():
		var node2d := node as Node2D
		if node2d == null:
			continue
		var pos := node2d.global_position
		pos.y += heroes_terrain_y_offset
		_add_hex(st, pos, heroes_terrain_layout)
	return st.commit() 


func _collect_grass_multimesh() -> MultiMesh:
	var multimesh := MultiMesh.new()
	multimesh.mesh = grass_mesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = grid.hex_count() * grass_density
	
	var instance_idx := 0
	
	for hex in grid.iterator():
		var center := hex_space.hex_to_pixel(hex)
		var corners: Array[Vector2] = []
		
		for idx in HexLayout.CORNER_NUM:
			var offset := hex_space.layout.hex_corner(idx) * hex_scale * grass_terrain_scale
			corners.append(center + offset)
		
		for idx in grass_density:
			var triangle := _rng.randi() % HexLayout.CORNER_NUM
			var a := center
			var b := corners[triangle]
			var c := corners[(triangle + 1) % HexLayout.CORNER_NUM]
			var point := Math.random_point_inside_triangle2d(_rng, a, b, c)
			var transform := Transform3D()
			transform.origin = board_projection.pixel_to_world(point)
			transform.basis = Basis(Vector3.RIGHT, -PI / 2)
			multimesh.set_instance_transform(instance_idx, transform)
			instance_idx += 1
	
	return multimesh


func _create_base_plane_mesh() -> Mesh:
	var plane := PlaneMesh.new()
	plane.size = Vector2(50.0, 70.0)
	return plane


func _build_terrain_mesh() -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for hex in grid.iterator():
		_add_hex(st, hex_space.hex_to_pixel(hex), hex_space.layout)
	return st.commit()


func _add_hex(st: SurfaceTool, pos: Vector2, layout: HexLayout):
	var center_top = board_projection.pixel_to_world(pos)
	var center_bottom = center_top + Vector3.DOWN * terrain_height

	var top_corners: Array[Vector3] = []
	var bottom_corners: Array[Vector3] = []

	for idx in HexLayout.CORNER_NUM:
		var corner_px = pos + layout.hex_corner(idx) * hex_scale
		var corner_top = board_projection.pixel_to_world(corner_px)

		top_corners.append(corner_top)
		bottom_corners.append(corner_top + Vector3.DOWN * terrain_height)

	_add_hex_cap(st, center_top, top_corners, true)
	_add_hex_cap(st, center_bottom, bottom_corners, false)

	for i in HexLayout.CORNER_NUM:
		var i_next = (i + 1) % 6
		_add_quad(
			st,
			top_corners[i],
			top_corners[i_next],
			bottom_corners[i_next],
			bottom_corners[i]
		)


func _add_hex_cap(st: SurfaceTool, center: Vector3, corners: Array[Vector3], is_top: bool):
	for i in HexLayout.CORNER_NUM:
		var a := center
		var b := corners[(i + 1) % 6]
		var c := corners[i]

		if not is_top:
			var tmp := b
			b = c
			c = tmp

		_add_triangle(st, a, b, c)


func _add_quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3):
	_add_triangle(st, a, b, c)
	_add_triangle(st, a, c, d)


func _add_triangle(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3):
	var normal = (c - a).cross(b - a).normalized()
	st.set_normal(normal)
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)


func _try_make_editor_owned(node: Node) -> void:
	if Engine.is_editor_hint():
		node.owner = get_tree().edited_scene_root
