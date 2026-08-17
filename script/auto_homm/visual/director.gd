class_name teVisualDirector extends teVisualDirectorBase


signal combat_event(event: teCombatEventBase, state: teCombatState)


@export var board: teBoardVisual
@export var projectile_system: teVisualProjectileSystem
@export var vfx_system: teVisualVfxSystem
@export var freeze_system: teVisualFreezeSystem
@export var movement_system: teVisualMovementSystem


func direct_take(action: teVisualActionBase, speed_scale := 1.0) -> teVisualTake:
	if action is teVisualActionUnitAct:
		var visuals = board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return teVisualTakes.fail("Can't get unit visuals to act")
		var actual_act := visuals.actual_act(action.act)
		if visuals.knows_act(actual_act):
			visuals.play_act(actual_act, speed_scale)
			return teVisualTakes.instant()
		if action.can_be_unknown:
			return teVisualTakes.instant()
		else:
			return teVisualTakes.fail("Visuals don't know act")
	if action is teVisualActionUnitWindup:
		var visuals := board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return teVisualTakes.fail("Can't get unit visuals to windup")
		if not visuals.knows_windup(action.act):
			return teVisualTakes.fail("Unit visuals don't know windup")
		return teVisualTakes.async(func(): await visuals.play_windup(action.act, speed_scale))
	if action is teVisualActionUnitCombo:
		var visuals = board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return teVisualTakes.fail("Can't get unit visuals to make combo")
		if not visuals.knows_combo(action.base_act, action.total):
			return teVisualTakes.fail("Visuals don't know combo")
		return teVisualTakes.async(func():
			await visuals.play_combo(action.base_act, speed_scale, action.idx, action.total)	
		)
	if action is teVisualActionUnitWaitWinddown:
		var visuals = board.get_unit_visuals(action.unit_id)
		if not visuals.is_acting():
			return teVisualTakes.instant()
		return teVisualTakes.signaled(visuals.act_finished_signal())
	if action is teVisualActionFreezeFrame:
		var freeze_time = action.duration / speed_scale
		freeze_system.stop_frame(freeze_time)
		return teVisualTakes.signaled(freeze_system.unfrozen)
	if action is teVisualActionEmitCombatEvents:
		for event in action.events:
			combat_event.emit(event, action.updated_state)
		return teVisualTakes.instant()
	if action is teVisualActionUnitFlash:
		var unit = board.get_unit(action.unit_id)
		if unit == null:
			return teVisualTakes.fail("Can't get unit to flash")
		var duration = action.time / speed_scale
		unit.flash(duration)
		if action.wait:
			return teVisualTakes.timer(self, duration)
		else:
			return teVisualTakes.instant()
	if action is teVisualActionUnitShootProjectile:
		var shooter := board.get_unit(action.shooter_id)
		var target := board.get_unit(action.target_id)
		var origin_pos := board.hex_space.to_local(shooter.get_socket(teVisualUnitSockets.RANGED))
		var target_pos := board.hex_space.to_local(target.get_socket(teVisualUnitSockets.TARGET))
		return direct_take(teVisualActions.shoot_projectile(
			origin_pos, target_pos,
			action.projectile_uid, action.speed_multiplier, action.trajectory_name
		))
	if action is teVisualActionShootProjectile:
		return teVisualTakes.async(
			func(): await projectile_system.shoot(
				action.projectile_uid, 
				action.origin,
				action.target,
				action.speed_multiplier * speed_scale
			)
		)
	if action is teVisualActionUnitGoIdle:
		board.get_unit_visuals(action.unit_id).go_idle()
		return teVisualTakes.instant()
	if action is teVisualActionUnitMove:
		var unit := board.get_unit(action.unit_id)
		if unit == null:
			return teVisualTakes.fail("Can't get unit to move")
		var visuals := board.get_unit_visuals(action.unit_id)
		var path: Array[Vector2] = []
		for point in action.path:
			path.push_back(board.hex_space.layout.hex_to_pixel(point))
		return teVisualTakes.async(func():
			visuals.start_moving()
			await movement_system.follow_path(
				unit,
				path,
				0.1 * path.size() / speed_scale # TODO: Replace with varying speed and etc.
			)
		)
	if action is teVisualActionVfxOnTarget:
		var unit := board.get_unit(action.target_unit_id)
		var pos := unit.get_socket(action.socket)
		return teVisualTakes.async(
			func(): await vfx_system.play(
				action.vfx_uid,
				pos,
				speed_scale,
				action.params
			)
		)
	if action is teVisualActionWait:
		return teVisualTakes.timer(self, action.time_sec / speed_scale)
	return teVisualTakes.fail("Unknown action type to direct")


func estimate_duration(action: teVisualActionBase) -> float:
	if action is teVisualActionUnitAct:
		return 0.0
	if action is teVisualActionUnitWindup:
		var visuals = board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return 0.0
		var actual_act := visuals.actual_act(action.act)
		if not visuals.knows_act(actual_act):
			return 0.0
		return visuals.windup_duration(actual_act)
	if action is teVisualActionUnitWaitWinddown:
		var visuals = board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return 0.0
		var actual_act := visuals.actual_act(action.act)
		if not visuals.knows_act(actual_act):
			return 0.0
		return visuals.winddown_duration(actual_act)
	if action is teVisualActionUnitCombo:
		var visuals = board.get_unit_visuals(action.unit_id)
		if visuals == null:
			return 0.0
		if not visuals.knows_combo(action.base_act, action.total):
			return 0.0
		return visuals.combo_duration(action.base_act, action.idx, action.total)
	if action is teVisualActionUnitFlash:
		if action.wait:
			return action.time
		else:
			return 0.0
	if action is teVisualActionUnitShootProjectile:
		var shooter := board.get_unit(action.shooter_id)
		var target := board.get_unit(action.target_id)
		var origin_pos := board.hex_space.to_local(shooter.get_socket(teVisualUnitSockets.RANGED))
		var target_pos := board.hex_space.to_local(target.get_socket(teVisualUnitSockets.TARGET))
		return projectile_system.estimate_shot_duration(
			action.projectile_uid,
			origin_pos,
			target_pos
		)
	if action is teVisualActionUnitMove:
		var path: Array[Vector2] = []
		for point in action.path:
			path.push_back(board.hex_space.layout.hex_to_pixel(point))
		return 0.1 * path.size()
	if action is teVisualActionVfxOnTarget:
		return vfx_system.duration(action.vfx_uid)
	if action is teVisualActionWait:
		return action.time_sec
	if action is teVisualActionEmitCombatEvents:
		return 0.0
	if action is teVisualActionFreezeFrame:
		return action.duration
	if action is teVisualActionUnitGoIdle:
		return 0.0
	print("Unknown estimate in director")
	return 0.0
