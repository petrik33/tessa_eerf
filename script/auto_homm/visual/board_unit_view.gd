class_name teBoardUnitView extends Node2D


@export var view_attach: Node2D
@export var marker_tracker: Node2D
@export var flash_vfx: teBoardUnitViewFlash


const SOCKET_METHODNAME_POSTFIX := "_socket"
const DEFAULT_TARGET_OFFSET := Vector2(0.0, -12.0)


var view: teUnitView


func get_socket(name: StringName) -> Vector2:
	var socket_method_name := name + SOCKET_METHODNAME_POSTFIX
	if view.visuals.has_method(socket_method_name):
		return view.visuals.call(socket_method_name)
	if name == &"target":
		return view.visuals.global_position + DEFAULT_TARGET_OFFSET
	return view.visuals.global_position


func get_marker_global_position() -> Vector2:
	return marker_tracker.global_position


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
