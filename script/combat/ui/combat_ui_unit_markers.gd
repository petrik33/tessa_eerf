class_name CombatUiUnitMarkers extends Node

@export var player: CombatPlayer
@export var visual: CombatVisual
@export var units_left_marker: PackedScene


func create_units_left_markers():
	var unit_handles := player.get_observed_state().get_all_unit_handles()
	for unit_handle in unit_handles:
		var attach_node = visual.get_unit(unit_handle).get_physical_node()
		var marker = units_left_marker.instantiate() as CombatUiUnitsLeftMarker
		attach_node.add_child(marker)
		_markers.push_back(marker)


func destroy_units_left_markers():
	for marker in _markers:
		marker.queue_free()
	_markers.clear()

var _markers: Array[CombatUiUnitsLeftMarker] = []
