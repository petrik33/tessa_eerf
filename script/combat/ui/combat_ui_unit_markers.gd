class_name CombatUiUnitMarkers extends Node

@export var observer: CombatObserver
@export var visual: CombatVisual
@export var units_left_marker: PackedScene

func create_units_left_markers():
	var units := observer.runtime().state().units
	for idx in units.size():
		var attach_node = visual.get_unit_physical_node(idx)
		var marker = units_left_marker.instantiate() as CombatUiUnitsLeftMarker
		attach_node.add_child(marker)
		_markers.push_back(marker)


func destroy_units_left_markers():
	for marker in _markers:
		marker.queue_free()
	_markers.clear()

var _markers: Array[CombatUiUnitsLeftMarker] = []
