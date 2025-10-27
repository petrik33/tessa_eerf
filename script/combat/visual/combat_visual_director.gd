class_name CombatVisualDirector extends Node


signal started(action: CombatVisualActionBase)
signal played(action: CombatVisualActionBase)
signal finished()


@export var units_map: CombatVisualUnitsMap
@export var units_node: Node2D
@export var projectiles_node: Node2D
@export var hex_layout: HexLayout


func get_unit(unit_handle: CombatUnitHandle) -> CombatVisualUnitBase:
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


func playing() -> bool:
	return _playing > 0


func queue_empty() -> bool:
	return _queue.is_empty()


func play(sequence: CombatVisualActionsQueue): 
	enqueue(sequence)
	if not playing():
		play_next()


func enqueue(sequence: CombatVisualActionsQueue):
	for action in sequence.actions:
		_queue.push_back(action)


func play_next():
	await play_action(_queue.pop_front())


func play_action(action: CombatVisualActionBase):
	_playing += 1
	await execute_action(action)
	_playing -= 1
	if playing():
		return
	if not queue_empty():
		play_next()
	else:
		finished.emit()


func execute_action(action: CombatVisualActionBase):
	if action is CombatVisualUnitActionBase:
		await get_unit(action.unit_handle).execute(action)
	if action is CombatParallelVisualActions:
		for sub_action in action.actions:
			play_action(sub_action)
	if action is CombatVisualActionsSubSequence:
		for sub_action in action.actions:
			await play_action(sub_action)
	if action is CombatVisualActionWaitUnitTrigger:
		await get_unit(action.unit_handle).executed
	if action is CombatVisualActionShootUnitProjectile:
		var shooter := get_unit(action.shooting_unit)
		var projectile = shooter.call("projectile", "ranged") as CombatVisualProjectile
		projectiles_node.add_child(projectile)
		projectile.global_position -= projectiles_node.global_position
		projectile.fire_at(action.target)
		await projectile.target_reached
		projectiles_node.remove_child(projectile)
		projectile.queue_free()
		


var _queue: Array[CombatVisualActionBase]
var _playing: int
var _is_setup: bool
var _units: Dictionary[String, CombatVisualUnitBase]


func _instantiate_unit_visuals(unit: Unit) -> CombatVisualUnitBase:
	var unit_scene = units_map.units[unit.uid]
	return unit_scene.instantiate()
