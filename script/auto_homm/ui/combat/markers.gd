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
	marker.set_hp(combat_unit.hp_left())
	marker.set_mana(combat_unit.mana_collected)
	marker.global_position = unit_view.get_marker_global_position()


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


func unit_update_hp(unit_id: int, diff: int):
	var marker = unit_markers[unit_id]
	if diff < 0:
		marker.decrease_hp(-diff)


func unit_update_mana(unit_id: int, diff: int):
	var marker = unit_markers[unit_id]
	if diff > 0:
		marker.increase_mana(diff)
