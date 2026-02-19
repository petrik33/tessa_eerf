class_name teBoardUnitView extends Node2D


@export var visuals_attach: Node2D

var is_dragged := false
var is_selected := false
var is_hovered := false


func set_hovered(hovered: bool):
	is_hovered = hovered


func set_selected(selected: bool):
	is_selected = selected
