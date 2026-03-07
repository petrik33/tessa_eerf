class_name teCombatUnitMarker extends Control


@onready var label: Label = %Label
@onready var panel: Panel = %Panel


var hp_level := 0


func decrease_hp(hp: int):
	set_hp(hp_level - hp)


func set_hp(hp: int):
	hp_level = hp
	_update_label_text()


func set_direction(hright: bool):
	var sbox = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	panel.add_theme_stylebox_override("panel", sbox)


func set_panel_color(color: Color):
	var sbox = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	sbox.bg_color = color
	panel.add_theme_stylebox_override("panel", sbox)


func _update_label_text():
	label.text = "%d" % [hp_level]
