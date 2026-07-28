class_name teBoardVisual extends Node


signal unit_attached(id: int, unit: teBoardUnitView)
signal unit_dettached(id: int, view: teUnitView)


@export var skin_set: teUnitSkinSet
@export var board_unit_view_scene: PackedScene
@export var unit_view_scene: PackedScene
@export var units_attach: Node2D
@export var hex_space: HexSpace
@export var hex_hover_outline: HexGridRendererBase
@export var pixel_art3d: teVisualPixelArt3d


var units: Dictionary[int, teBoardUnitView]


func sync_state(combat: teCombatState):
	sync_units(combat)
	if pixel_art3d != null:
		pixel_art3d.sync(combat)


func sync_units(combat: teCombatState):
	var combat_units_id := combat.all_units_id()
	for unit_id in units:
		if not combat_units_id.has(unit_id):
			destroy_unit(unit_id)
	for unit_id in combat_units_id:
		var combat_unit := combat.unit(unit_id)
		if not units.has(unit_id):
			create_unit(combat_unit.definition_uid, unit_id)
		units[unit_id].position = hex_space.layout.hex_to_pixel(combat_unit.hex)
		units[unit_id].view.visuals.face(get_unit_idle_facing(combat.unit_team_id(unit_id)))


func clear_all_hover():
	clear_units_hover()
	clear_hex_hover()


func clear_units_hover():
	for unit_id in units:
		units[unit_id].set_hovered(false)


func clear_hex_hover():
	hex_hover_outline.grid = null


func hover_hex(hex: Vector2i):
	hex_hover_outline.grid = HexGrids.point(hex)


func hover_unit(unit_id: int):
	units[unit_id].set_hovered(true)


func unhover_unit(unit_id: int):
	units[unit_id].set_hovered(false)


func deselect_unit(unit_id: int):
	units[unit_id].set_selected(false)


func select_unit(unit_id: int):
	units[unit_id].set_selected(true)


func create_unit(uid: StringName, id: int) -> teBoardUnitView:
	var visuals := skin_set.scenes[uid].instantiate() as teUnitVisualsBase
	units_attach.add_child(visuals)
	var unit_view := create_unit_view(visuals)
	units_attach.add_child(unit_view)
	return attach_unit(unit_view, id)


func destroy_unit(id: int):
	var unit_view := dettach_unit(id)
	unit_view.queue_free()


func attach_unit(unit_view: teUnitView, id: int) -> teBoardUnitView:
	var board_unit_view := board_unit_view_scene.instantiate() as teBoardUnitView
	board_unit_view.attach_view(unit_view)
	units_attach.add_child(board_unit_view)
	units[id] = board_unit_view
	unit_attached.emit(id, board_unit_view)
	return board_unit_view


func dettach_unit(id: int) -> teUnitView:
	var board_unit_view = units[id]
	units.erase(id)
	units_attach.remove_child(board_unit_view)
	var dettached_unit := board_unit_view.dettach_view()
	board_unit_view.queue_free()
	unit_dettached.emit(id, dettached_unit)
	return dettached_unit


func create_unit_view(visuals: teUnitVisualsBase) -> teUnitView:
	var unit_view := unit_view_scene.instantiate() as teUnitView
	unit_view.attach_visuals(visuals)
	return unit_view


func get_unit(id: int) -> teBoardUnitView:
	return units[id]


func get_unit_visuals(id: int) -> teUnitVisualsBase:
	return get_unit(id).view.visuals


func get_unit_idle_facing(side: int) -> float:
	if side == 0:
		return 0.0
	return PI
