class_name CombatVisualDirector extends Node

@export var units_map: CombatVisualUnitsMap
@export var units_node: Node
@export var hex_layout: HexLayout

func get_unit(idx: int) -> CombatVisualUnit:
	return units_node.get_child(idx)

func setup_scene(runtime: CombatRuntime):
	assert(not _is_setup, "Scene already setup")
	for unit in runtime.state().units:
		var visuals = _instantiate_unit_visuals(unit.data)
		units_node.add_child(visuals)
	_is_setup = true

func clear_scene():
	assert(_is_setup, "Scene not setup yet")
	for idx in units_node.get_child_count():
		get_unit(idx).queue_free()

func play(queue: CombatVisualActionsQueue):
	#assert(not _is_playing, "Already playing")
	_is_playing = true
	for action in queue.actions:
		if action is CombatVisualUnitActionBase:
			await get_unit(action.unit_idx).execute(action)
			continue
	_is_playing = false

var _is_playing: bool
var _is_setup: bool

func _instantiate_unit_visuals(unit: UnitData) -> CombatVisualUnit:
	var unit_scene = units_map.units[unit.uid]
	return unit_scene.instantiate()
