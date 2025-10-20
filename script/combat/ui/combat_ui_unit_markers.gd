class_name CombatUiUnitMarkers extends Node


@export var units_left_marker: PackedScene


func create_units_left_markers(visual: CombatVisual, state: CombatState):
	for unit_handle in state.all_unit_handles():
		var attach_node = visual.get_unit(unit_handle).get_physical_node()
		var marker = units_left_marker.instantiate() as CombatUiUnitMarker
		attach_node.add_child(marker)
		_markers[unit_handle.id()] = marker
		marker.army_id = state.unit(unit_handle).army_handle.id()
	update(state)


func destroy_units_left_markers():
	for marker in _markers.values():
		marker.queue_free()
	_markers.clear()


func update(state: CombatState):
	for unit_handle in state.all_unit_handles():
		var unit := state.unit(unit_handle)
		var marker := _markers[unit_handle.id()]
		marker.set_stack_size(unit.stack_size)
		var turn_place := state.place_in_turn_queue(unit_handle)
		marker.next_turn_progress = float(turn_place) / state.turn_queue.size()


var _markers: Dictionary[String, CombatUiUnitMarker] = {}
