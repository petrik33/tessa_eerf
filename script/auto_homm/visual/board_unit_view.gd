class_name teBoardUnitView extends Node2D


@export var view_attach: Node2D
@export var marker_tracker: Node2D
@export var hero_marker_tracker: Node2D
@export var flash_vfx: teBoardUnitViewFlash


var view: teUnitView


func get_marker_global_position() -> Vector2:
	return marker_tracker.global_position

func get_hero_marker_global_position() -> Vector2:
	return hero_marker_tracker.global_position


func flash(time := 0.1, color := Color.WHITE):
	flash_vfx.flash(time, color)


func set_hovered(hovered: bool):
	view.set_hovered(hovered)


func set_selected(selected: bool):
	view.set_selected(selected)


func attach_view(node: teUnitView):
	node.position = Vector2.ZERO
	node.reparent(view_attach, false)
	view = node
	flash_vfx.set_target(view.visuals.node_to_glow)


func dettach_view() -> teUnitView:
	flash_vfx.reset_target()
	view_attach.remove_child(view)
	var dettached_node := view
	view = null
	return dettached_node
