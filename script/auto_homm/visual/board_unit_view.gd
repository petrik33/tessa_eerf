class_name teBoardUnitView extends Node2D


@export var unit_view_attach: Node2D


var unit_view: teUnitView


func set_hovered(hovered: bool):
	unit_view.set_hovered(hovered)


func set_selected(selected: bool):
	unit_view.set_selected(selected)


func attach_unit_view(node: teUnitView):
	node.position = Vector2.ZERO
	node.reparent(unit_view_attach, false)
	unit_view = node


func dettach_unit_view() -> teUnitView:
	unit_view_attach.remove_child(unit_view)
	var dettached_node := unit_view
	unit_view = null
	return dettached_node
