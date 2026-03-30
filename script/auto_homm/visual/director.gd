class_name teVisualDirector extends Node


@export var board: teBoardVisual
@export var projectile_system: teVisualProjectileSystem


signal started(action: teVisualActionBase)
signal played(action: teVisualActionBase)

signal sequence_finished()

signal combat_event(event: teCombatEventBase)


func playing() -> bool:
	return _playing > 0


func queue_empty() -> bool:
	return _queue.is_empty()


func play(sequence: teVisualSequence):
	enqueue(sequence)
	if not playing():
		play_next()


func enqueue(sequence: teVisualSequence):
	_queue.push_back(sequence)


func play_next():
	var sequence = _queue.pop_front()
	while sequence.actions.is_empty():
		if _queue.is_empty():
			return
		sequence = _queue.pop_front()
	for action in sequence.actions:
		await play_action(action)
	sequence_finished.emit()


func play_action(action: teVisualActionBase):
	_playing += 1
	started.emit(action)
	await direct_action(action)
	played.emit(action)
	_playing -= 1
	if playing():
		return
	if not queue_empty():
		play_next()


func direct_action(action: teVisualActionBase):
	if action is teVisualActionParallel:
		for sub_action in action.actions:
			play_action(sub_action)
	if action is teVisualActionSubSequence:
		for sub_action in action.actions:
			await play_action(sub_action)
	if action is teVisualActionUnitWindup:
		var visuals := board.get_unit_visuals(action.unit_id)
		if not visuals.winding_up:
			return
		await visuals.windup
	if action is teVisualActionUnitSequence:
		var visuals = board.get_unit_visuals(action.unit_id)
		for act in action.acts:
			var method_name := teVisualActs.name(act)
			if not visuals.has_method(method_name):
				continue
			await visuals.call(method_name, act)
		visuals.go_idle()
	if action is teVisualActionFreezeFrame:
		var old_scale := Engine.time_scale
		Engine.time_scale = action.time_scale
		await get_tree().create_timer(action.duration, true, false, true).timeout
		Engine.time_scale = old_scale
	if action is teVisualActionEmitCombatEvent:
		combat_event.emit(action.event)
	if action is teVisualActionUnitFlash:
		var unit = board.get_unit(action.unit_id)
		unit.flash()
	if action is teVisualActionUnitShootProjectile:
		var shooter := board.get_unit(action.shooter_id)
		var target := board.get_unit(action.target_id)
		var projectile := projectile_system.create(
			action.projectile_uid,
			board.hex_space.to_local(shooter.get_socket(&"ranged")),
			board.hex_space.to_local(target.get_socket(&"target")),
			action.speed_multiplier,
			action.trajectory_name
		)
		await projectile.reached_target
		projectile_system.destroy(projectile)
	if action is teVisualActionUnitDie:
		var unit_visuals := board.get_unit_visuals(action.unit_id)
		if unit_visuals.has_method("die"):
			await unit_visuals.call("die", teVisualActDie.new())
		board.dettach_unit(action.unit_id)
		


func clear_queue():
	_queue.clear()


var _queue: Array[teVisualSequence]
var _playing: int
