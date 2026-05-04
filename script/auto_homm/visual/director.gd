class_name teVisualDirector extends teVisualDirectorBase


signal combat_event(event: teCombatEventBase)


@export var board: teBoardVisual
@export var projectile_system: teVisualProjectileSystem
@export var vfx_system: teVisualVfxSystem
@export var freeze_system: teVisualFreezeSystem
@export var movement_system: teVisualMovementSystem


func direct_take(action: teVisualActionBase, speed_scale := 1.0) -> teVisualTake:
	if action is teVisualActionUnitWindup:
		var visuals := board.get_unit_visuals(action.unit_id)
		if not visuals.is_winding_up(action.act):
			return teVisualTakes.fail()
		if visuals.windup_finished(action.act):
			return teVisualTakes.instant()
		return teVisualTakes.signaled(visuals.windup_signal(action.act))
	if action is teVisualActionUnitAct:
		var visuals = board.get_unit_visuals(action.unit_id)
		if not visuals.knows_act(action.act):
			return teVisualTakes.instant()
		var take := teVisualTakes.async(
			func(): await visuals.play_act(action.act, speed_scale)
		)
		if action.go_idle:
			take.cut.connect(func(): visuals.go_idle())
		return take
	if action is teVisualActionFreezeFrame:
		var freeze_time = action.duration / speed_scale
		freeze_system.freeze_frame(freeze_time, action.time_scale)
		return teVisualTakes.timer(self, freeze_time)
	if action is teVisualActionEmitCombatEvent:
		combat_event.emit(action.event)
		return teVisualTakes.instant()
	if action is teVisualActionUnitFlash:
		var unit = board.get_unit(action.unit_id)
		if unit == null:
			return teVisualTakes.fail()
		var duration = action.time / speed_scale
		unit.flash(duration)
		return teVisualTakes.timer(self, duration)
	if action is teVisualActionUnitShootProjectile:
		var shooter := board.get_unit(action.shooter_id)
		var target := board.get_unit(action.target_id)
		var origin_pos := board.hex_space.to_local(shooter.get_socket(&"ranged"))
		var target_pos := board.hex_space.to_local(target.get_socket(&"target"))
		return teVisualTakes.async(
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
		var take := teVisualTakes.async(
			func(): await unit_visuals.play_act(last_act, speed_scale)
		)
		take.cut.connect(func(): board.dettach_unit(action.unit_id))
		return take
	if action is teVisualActionUnitGoIdle:
		board.get_unit_visuals(action.unit_id).go_idle()
		return teVisualTakes.instant()
	if action is teVisualActionUnitMove:
		var unit := board.get_unit(action.unit_id)
		if unit == null:
			return teVisualTakes.fail()
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
		var pos := board.hex_space.to_local(unit.get_socket(action.socket))
		return teVisualTakes.async(
			func(): await vfx_system.play(
				action.vfx_uid,
				pos,
				board.hex_space,
				speed_scale,
				action.params
			)
		)
	return teVisualTakes.fail()


func estimate_duration(action: teVisualActionBase) -> float:
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
