class_name CombatVisualDirector extends Node


@export var units_map: CombatVisualUnitsMap
@export var units_node: Node2D
@export var hex_layout: HexLayout


func get_unit(unit_handle: CombatUnitHandle) -> CombatVisualUnit:
	return _units[unit_handle.id()]


func setup_scene(state: CombatState):
	assert(not _is_setup, "Scene already setup")
	for unit_handle in state.all_unit_handles():
		var unit = state.unit(unit_handle)
		var visuals = _instantiate_unit_visuals(unit.unit)
		visuals.get_physical_node().position = hex_layout.hex_to_pixel(unit.placement)
		units_node.add_child(visuals)
		_units[unit_handle.id()] = visuals
	_is_setup = true


func clear_scene():
	assert(_is_setup, "Scene not setup yet")
	for visuals in _units.values():
		visuals.queue_free()
	_units.clear()
	_is_setup = false


func play(queue: CombatVisualActionsQueue):
	#assert(not _is_playing, "Already playing")
	_is_playing = true
	for action in queue.actions:
		if action is CombatVisualUnitActionBase:
			await get_unit(action.unit_handle).execute(action)
			continue
	_is_playing = false


var _is_playing: bool
var _is_setup: bool
var _units: Dictionary[String, CombatVisualUnit]


func _instantiate_unit_visuals(unit: Unit) -> CombatVisualUnit:
	var unit_scene = units_map.units[unit.uid]
	return unit_scene.instantiate()
