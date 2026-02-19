class_name teBoardView extends Node2D


@export var unit_view_scene: PackedScene
@export var units_attach: Node2D
@export var hex_space: HexSpace


var units: Dictionary[int, teBoardUnitView]


func attach_unit(visuals: Node2D, id: int) -> teBoardUnitView:
	var unit_view := unit_view_scene.instantiate() as teBoardUnitView
	units_attach.add_child(unit_view)
	visuals.position = Vector2.ZERO
	visuals.reparent(unit_view.visuals_attach)
	units[id] = unit_view
	return unit_view


func dettach_unit(id: int) -> teBoardUnitView:
	var unit_view = units[id]
	units.erase(id)
	units_attach.remove_child(unit_view)
	return unit_view


func get_unit(id: int) -> teBoardUnitView:
	return units[id]
