class_name teCombatUnitMarker extends Control


@export var hp_label: Label
@export var hp_panel: Panel
@export var mana_label: Label
@export var mana_panel: Panel


var hp_level := 0
var mana_level := 0


func increase_mana(mana: int):
	set_mana(mana_level + mana)


func set_mana(mana: int):
	mana_level = mana
	_update_mana_label_text()


func decrease_hp(hp: int):
	set_hp(max(hp_level - hp, 0))


func set_hp(hp: int):
	hp_level = hp
	_update_hp_label_text()


func set_direction(hright: bool):
	# Unfinished
	var sbox = hp_panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	hp_panel.add_theme_stylebox_override("panel", sbox)


func set_panel_color(color: Color):
	var sbox = hp_panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	sbox.bg_color = color
	hp_panel.add_theme_stylebox_override("panel", sbox)


func _update_hp_label_text():
	hp_label.text = "%d" % [hp_level]


func _update_mana_label_text():
	mana_label.text = "%d" % [mana_level]
