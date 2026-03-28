class_name teUnitView extends Node2D


@export var glow: teUnitViewGlow

@export var dragged_glow_strength := 1.0
@export var selected_glow_strength := 0.9
@export var hovered_glow_strength := 0.6


var visuals: teUnitVisualsBase

var is_dragged := false
var is_selected := false
var is_hovered := false


func attach_visuals(visuals_node: teUnitVisualsBase):
	visuals = visuals_node
	glow.setup(visuals.node_to_glow)


func set_hovered(hovered: bool):
	is_hovered = hovered
	update_glow()


func set_selected(selected: bool):
	is_selected = selected
	update_glow()


func update_glow():
	glow.update(get_glow_target())


func get_glow_target() -> float:
	if is_dragged:
		return dragged_glow_strength
	elif is_selected:
		return selected_glow_strength
	elif is_hovered:
		return hovered_glow_strength
	return 0.0
