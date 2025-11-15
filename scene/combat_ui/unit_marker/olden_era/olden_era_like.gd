@tool
class_name OldenEraLikeUnitMarker extends Control

@export var label: Label
@export var panel: Panel


func set_stack_size(count: int):
	label.text = "%d" % [count]


func set_panel_sbox(sbox: StyleBox):
	panel.add_theme_stylebox_override("panel", sbox)
