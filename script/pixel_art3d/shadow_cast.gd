class_name PixelArt3dShadowCast extends Node


@export var board: teBoardVisual
@export var bridge: PixelArt3dSpaceBridge
@export var directional_light: DirectionalLight3D
@export var container: Node3D
@export var shadow_mesh_scene: PackedScene
@export var light_offset: float = 0.5


var unit_shadow_mesh: Dictionary[int, Node3D]


func _process(_delta: float) -> void:
	sync_mesh_positions()


func sync_units(state: teCombatState):
	for unit_id in state.all_units_id():
		sync_shadow_mesh(unit_id, state)
	for unit_id in unit_shadow_mesh:
		if not state.has_unit(unit_id):
			var shadow_mesh = unit_shadow_mesh[unit_id]
			unit_shadow_mesh.erase(unit_id)
			destroy_shadow_mesh(shadow_mesh)
	sync_mesh_positions()


func sync_shadow_mesh(unit_id: int, _state: teCombatState):
	var shadow_mesh: Node3D = unit_shadow_mesh.get(unit_id)
	if shadow_mesh == null:
		unit_shadow_mesh[unit_id] = create_shadow_mesh()
		shadow_mesh = unit_shadow_mesh[unit_id]


func sync_mesh_positions():
	var light_direction := -directional_light.global_transform.basis.z
	var ground_direction := -Vector3(light_direction.x, 0, light_direction.z).normalized()
	var shadow_offset := ground_direction * light_offset
	
	for unit_id in unit_shadow_mesh:
		var unit_view := board.get_unit(unit_id)
		var mesh := unit_shadow_mesh[unit_id]
		var projected_pos := bridge.project_to_ground_plane(unit_view.global_position)
		mesh.global_position = projected_pos + shadow_offset


func create_shadow_mesh() -> Node3D:
	var shadow_mesh: Node3D = shadow_mesh_scene.instantiate()
	container.add_child(shadow_mesh)
	return shadow_mesh


func destroy_shadow_mesh(shadow_mesh: Node3D):
	container.remove_child(shadow_mesh)
	shadow_mesh.queue_free()
