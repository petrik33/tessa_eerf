@tool
class_name CombatUiUnitMarker extends Control


@onready var label: Label = %Label
@onready var panel: Panel = %Panel


func set_stack_size(count: int):
	label.text = "%d" % [count]


func set_direction(hright: bool):
	var sbox = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	panel.add_theme_stylebox_override("panel", sbox)


func set_panel_color(color: Color):
	var sbox = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	sbox.bg_color = color
	panel.add_theme_stylebox_override("panel", sbox)
