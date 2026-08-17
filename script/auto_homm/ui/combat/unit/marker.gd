class_name teCombatUnitMarker
extends Control


@export var hp_bar: TextureProgressBar
@export var hp_damage_bar: TextureProgressBar
@export var mana_bar: TextureProgressBar
@export var hp_segments: RangeSegments

@export var hp_label: Label
@export var name_label: Label

@export var status_border: teCombatUnitStatusBorder
@export var bg_panel: Panel

@export var panel_style_idle: StyleBox
@export var panel_style_active: StyleBox

@export var active: bool:
	set(value):
		if value == active:
			return
		active = value
		if bg_panel == null:
			return
		if active:
			if panel_style_active == null:
				return
			bg_panel.remove_theme_stylebox_override(&"panel")
			bg_panel.add_theme_stylebox_override(&"panel", panel_style_active)
		else:
			if panel_style_idle == null:
				return
			bg_panel.remove_theme_stylebox_override(&"panel")
			bg_panel.add_theme_stylebox_override(&"panel", panel_style_idle)


var max_hp := 100
var hp := 100

var max_mana := 100
var mana := 0

var displayed_damage_hp := 100.0


func _ready() -> void:
	hp_bar.share(hp_segments)


func _process(delta: float):
	displayed_damage_hp = move_toward(
		displayed_damage_hp,
		hp,
		delta * 80.0
	)

	hp_damage_bar.value = displayed_damage_hp


func set_unit_name(value: String):
	name_label.text = value


func set_hp_values(current: int, maximum: int):
	hp = current
	max_hp = maximum

	hp_bar.max_value = max_hp
	hp_bar.value = hp

	hp_damage_bar.max_value = max_hp

	_update_hp_label()
	_update_hp_color()


func set_mana_values(current: int, maximum: int):
	mana = current
	max_mana = maximum

	mana_bar.max_value = max_mana
	mana_bar.value = mana


func set_effects(effects: Dictionary[int, teCombatEffectInstance]):
	status_border.clear()
	for id in effects:
		var inst := effects[id]
		if not status_border.shows_effect(teCombatEffects.get_common_effect_name(inst.effect)):
			continue
		status_border.add_effect_instance(inst, id)


func remove_effect(inst: teCombatEffectInstance, id: int):
	if status_border.shows_effect(teCombatEffects.get_common_effect_name(inst.effect)):
		status_border.remove_effect_instancec(inst, id)


func add_mana(value: int):
	set_mana_values(mana + value, max_mana)


func spend_mana(value: int):
	set_mana_values(mana - value, max_mana)


func damage(value: int):
	set_hp_values(max(hp - value, 0), max_hp)


func flash_effect(effect_name: StringName):
	if status_border.shows_effect(effect_name):
		status_border.flash(effect_name)


func heal(value: int):
	set_hp_values(min(hp + value, max_hp), max_hp)


func _update_hp_label():
	hp_label.text = "%d/%d" % [hp, max_hp]


func _update_hp_color():
	var ratio := float(hp) / float(max_hp)

	if ratio > 0.6:
		hp_bar.tint_progress = Color("4CAF50")
	elif ratio > 0.3:
		hp_bar.tint_progress = Color("FFC107")
	else:
		hp_bar.tint_progress = Color("E53935")
