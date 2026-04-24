class_name teVisualDirector extends Node


@export var board: teBoardVisual
@export var projectile_system: teVisualProjectileSystem
@export var vfx_system: teVisualVfxSystem
@export var freeze_system: teVisualFreezeSystem
@export var movement_system: teVisualMovementSystem


signal started(action: teVisualActionBase)
signal played(action: teVisualActionBase)

signal sequence_finished()

signal combat_event(event: teCombatEventBase)


func playing() -> bool:
	return _playing > 0


func queue_empty() -> bool:
	return _queue.is_empty()


func play(action: teVisualActionBase, time_sec: float = -1.0):
	enqueue(action)
	if playing():
		return
	while not queue_empty():
		var current = _queue.pop_front()
		var estimated := estimate_duration(current)
		var speed_scale = max(estimated / time_sec, 1.0)
		await play_action(current, speed_scale)
		sequence_finished.emit()


func enqueue(action: teVisualActionBase):
	_queue.push_back(action)


func play_action(action: teVisualActionBase, speed_scale := 1.0):
	_playing += 1
	started.emit(action)

	var track := direct_action(action, speed_scale)
	track.play()

	if not track.is_done:
		await track.finished

	_playing -= 1
	played.emit(action)


func direct_action(action: teVisualActionBase, speed_scale := 1.0) -> teVisualDirectorTrackBase:
	if action is teVisualActionParallel:
		return teVisualDirectorTracks.parallel(action, self, speed_scale)
	if action is teVisualActionSubSequence:
		return  teVisualDirectorTracks.sequential(action, self, speed_scale)
	if action is teVisualActionUnitWindup:
		var visuals := board.get_unit_visuals(action.unit_id)
		if not visuals.is_winding_up(action.act):
			return teVisualDirectorTracks.fail()
		if visuals.windup_finished(action.act):
			return teVisualDirectorTracks.instant()
		return teVisualDirectorTracks.signaled(visuals.windup_signal(action.act))
	if action is teVisualActionUnitAct:
		var visuals = board.get_unit_visuals(action.unit_id)
		if not visuals.knows_act(action.act):
			return teVisualDirectorTracks.instant()
		var track := teVisualDirectorTracks.coroutine(
			func(): await visuals.play_act(action.act, speed_scale)
		)
		if action.go_idle:
			track.finished.connect(func(): visuals.go_idle())
		return track
	if action is teVisualActionFreezeFrame:
		return teVisualDirectorTracks.signaled(
			freeze_system.freeze_frame(action.duration / speed_scale, action.time_scale)
		)
	if action is teVisualActionEmitCombatEvent:
		combat_event.emit(action.event)
		return teVisualDirectorTracks.instant()
	if action is teVisualActionUnitFlash:
		var unit = board.get_unit(action.unit_id)
		if unit == null:
			return teVisualDirectorTracks.fail()
		var duration = action.time / speed_scale
		unit.flash(duration)
		return teVisualDirectorTracks.timer(self, duration)
	if action is teVisualActionUnitShootProjectile:
		var shooter := board.get_unit(action.shooter_id)
		var target := board.get_unit(action.target_id)
		var origin_pos := board.hex_space.to_local(shooter.get_socket(&"ranged"))
		var target_pos := board.hex_space.to_local(target.get_socket(&"target"))
		return teVisualDirectorTracks.coroutine(
			func(): await projectile_system.shoot(
				action.projectile_uid, 
				origin_pos,
				target_pos,
				action.speed_multiplier * speed_scale
			)
		)
	if action is teVisualActionUnitDie:
		var unit_visuals := board.get_unit_visuals(action.unit_id)
		var last_act := teVisualActs.DIE
		if not unit_visuals.knows_act(teVisualActs.DIE):
			last_act = teVisualActs.GET_HURT
		var track := teVisualDirectorTracks.coroutine(
			func(): await unit_visuals.play_act(last_act, speed_scale)
		)
		track.finished.connect(func(): board.dettach_unit(action.unit_id))
		return track
	if action is teVisualActionUnitGoIdle:
		board.get_unit_visuals(action.unit_id).go_idle()
		return teVisualDirectorTracks.instant()
	if action is teVisualActionUnitMove:
		var unit := board.get_unit(action.unit_id)
		if unit == null:
			return teVisualDirectorTracks.fail()
		var visuals := board.get_unit_visuals(action.unit_id)
		var path: Array[Vector2] = []
		for point in action.path:
			path.push_back(board.hex_space.layout.hex_to_pixel(point))
		return teVisualDirectorTracks.coroutine(func():
			visuals.start_moving()
			await movement_system.follow_path(
				unit,
				path,
				0.1 * path.size() / speed_scale # TODO: Replace with varying speed and etc.
			)
		)
	if action is teVisualActionVfxOnTarget:
		var unit := board.get_unit(action.target_unit_id)
		var pos := board.hex_space.to_local(unit.get_socket(action.socket))
		return teVisualDirectorTracks.coroutine(
			func(): await vfx_system.play(
				action.vfx_uid,
				pos,
				board.hex_space,
				speed_scale,
				action.params
			)
		)
	return teVisualDirectorTracks.fail()


func estimate_duration(action: teVisualActionBase) -> float:
	if action is teVisualActionParallel:
		var max_duration := 0.0
		for sub_action in action.actions:
			max_duration = max(max_duration, estimate_duration(sub_action))
		return max_duration
	if action is teVisualActionSubSequence:
		var total_duration := 0.0
		for sub_action in action.actions:
			total_duration += estimate_duration(sub_action)
		return total_duration
	if action is teVisualActionUnitWindup:
		return estimate_duration(teVisualActions.unit_act(action.unit_id, action.act))
	if action is teVisualActionUnitAct:
		var visuals = board.get_unit_visuals(action.unit_id)
		return visuals.act_duration(action.act)
	if action is teVisualActionFreezeFrame:
		return action.duration
	if action is teVisualActionUnitFlash:
		return action.time
	if action is teVisualActionUnitShootProjectile:
		return 0.0
	if action is teVisualActionUnitDie:
		var unit_visuals := board.get_unit_visuals(action.unit_id)
		var last_act := teVisualActs.DIE
		if not unit_visuals.knows_act(teVisualActs.DIE):
			last_act = teVisualActs.GET_HURT
		return estimate_duration(teVisualActions.unit_act(action.unit_id, last_act))
	if action is teVisualActionUnitMove:
		var path: Array[Vector2] = []
		for point in action.path:
			path.push_back(board.hex_space.layout.hex_to_pixel(point))
		return 0.1 * path.size()
	if action is teVisualActionVfxOnTarget:
		return vfx_system.duration(action.vfx_uid)
	return 0.0


func clear_queue():
	_queue.clear()


var _queue: Array[teVisualActionBase]
var _playing: int
