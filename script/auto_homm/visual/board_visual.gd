class_name teBoardVisual extends Node


@export var skin_set: teUnitSkinSet
@export var unit_view_scene: PackedScene
@export var board_unit_view_scene: PackedScene
@export var units_attach: Node2D
@export var hex_space: HexSpace
@export var hex_hover_outline: HexGridRendererBase


var units: Dictionary[int, teBoardUnitView]


func sync_state(combat: teCombatState):
	for unit_id in combat.all_units_id():
		var unit := combat.unit(unit_id)
		if not units.has(unit_id):
			create_unit(unit.definition_uid, unit_id)
		units[unit_id].position = hex_space.layout.hex_to_pixel(unit.hex)


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


func deselect_unit(unit_id: int):
	units[unit_id].set_selected(false)


func select_unit(unit_id: int):
	units[unit_id].set_selected(true)


func create_unit(uid: StringName, id: int) -> teBoardUnitView:
	var visuals := skin_set.scenes[uid].instantiate() as teUnitVisualsBase
	var unit_view := unit_view_scene.instantiate() as teUnitView
	unit_view.attach_visuals(visuals)
	return attach_unit(unit_view, id)


func attach_unit(unit_view: teUnitView, id: int) -> teBoardUnitView:
	var board_unit_view := board_unit_view_scene.instantiate() as teBoardUnitView
	board_unit_view.attach_view(unit_view)
	units_attach.add_child(board_unit_view)
	units[id] = board_unit_view
	return board_unit_view


func dettach_unit(id: int) -> teUnitView:
	var board_unit_view = units[id]
	units.erase(id)
	units_attach.remove_child(board_unit_view)
	var dettached_unit := board_unit_view.dettach_view()
	board_unit_view.queue_free()
	return dettached_unit


func get_unit(id: int) -> teBoardUnitView:
	return units[id]


func get_unit_visuals(id: int) -> teUnitVisualsBase:
	return get_unit(id).view.visuals
