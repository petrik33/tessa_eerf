class_name teCombatUiMarkers extends Node


@export var markers_container: Node2D
@export var board: teBoardVisual
@export var unit_marker_scene: PackedScene


var unit_markers: Dictionary[int, teCombatUnitMarker]


func _process(_delta: float) -> void:
	sync_positions()


func sync(state: teCombatState):
	for unit_id in state.all_units_id():
		sync_unit_marker(unit_id, state)
	for unit_id in unit_markers:
		if not state.has_unit(unit_id):
			var marker = unit_markers[unit_id]
			unit_markers.erase(unit_id)
			destroy_marker(marker)
	sync_positions()


func sync_positions():
	for unit_id in unit_markers:
		var unit_view := board.get_unit(unit_id)
		var marker := unit_markers[unit_id]
		marker.global_position = unit_view.get_marker_global_position()


func sync_unit_marker(unit_id: int, state: teCombatState):
	var combat_unit := state.unit(unit_id)
	var unit_view := board.get_unit(unit_id)
	var marker: teCombatUnitMarker = unit_markers.get(unit_id)
	if marker == null:
		unit_markers[unit_id] = create_marker()
		marker = unit_markers[unit_id]
	marker.set_hp_values(combat_unit.hp_left(), combat_unit.stats.max_hp)
	marker.set_mana_values(combat_unit.mana_collected, combat_unit.stats.required_mana)
	marker.set_effects(combat_unit.effects)
	marker.global_position = unit_view.get_marker_global_position()


func unit_set_effects(unit_id: int, effects: Dictionary[int, teCombatEffectInstance]):
	unit_markers[unit_id].set_effects(effects)


func create_marker() -> teCombatUnitMarker:
	var marker: teCombatUnitMarker = unit_marker_scene.instantiate()
	markers_container.add_child(marker)
	return marker


func destroy_marker(marker: teCombatUnitMarker):
	markers_container.remove_child(marker)
	marker.queue_free()


func unit_remove_marker(unit_id: int):
	if not unit_markers.has(unit_id):
		return
	var marker = unit_markers[unit_id]
	unit_markers.erase(unit_id)
	destroy_marker(marker)


func unit_set_active(unit_id: int, value: bool):
	unit_markers[unit_id].active = value


func unit_damage(unit_id: int, inst: teCombatDamageInstance):
	unit_markers[unit_id].damage(floor(inst.base_amount)) # TODO: Potential info loss
	if teCombatDamage.source_is_effect(inst.source):
		unit_markers[unit_id].flash_effect(teCombatDamage.source_what_effect(inst.source))


func unit_gain_mana(unit_id: int, mana: int):
	unit_markers[unit_id].add_mana(mana)


func unit_spend_mana(unit_id: int, mana: int):
	unit_markers[unit_id].spend_mana(mana)
