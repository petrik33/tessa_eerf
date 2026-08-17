class_name teVisualActions


func _init() -> void:
	Utils.assert_static_lib()


static func parallel(... actions: Array) -> teVisualActionParallel:
	var action := teVisualActionParallel.new()
	action.actions = collect_sub_actions(actions)
	return action

static func sub_sequence(... actions: Array) -> teVisualActionSubSequence:
	var action := teVisualActionSubSequence.new()
	action.actions = collect_sub_actions(actions)
	return action

static func background(sub_action: teVisualActionBase) -> teVisualActionBackground:
	var action := teVisualActionBackground.new()
	action.sub_action = sub_action
	return action

static func wait(time_sec: float) -> teVisualActionWait:
	var action := teVisualActionWait.new()
	action.time_sec = time_sec
	return action

static func unit_combo_sequence(
	unit_id: int,
	base_act: StringName,
	combo_length: int,
	combo_idx: int,
	on_combo: teVisualActionBase,
) -> teVisualActionBase:
	return sub_sequence(
		unit_combo(unit_id, base_act, combo_idx, combo_length),
		on_combo
	)

static func unit_windup_sequence(
	unit_id: int,
	act: StringName,
	on_windup: teVisualActionBase
) -> teVisualActionBase:
	return sub_sequence(unit_windup(unit_id, act), on_windup)

static func unit_act(
	unit_id: int,
	act: StringName,
	can_be_unknown: bool = false
) -> teVisualActionBase:
	var action := teVisualActionUnitAct.new()
	action.unit_id = unit_id
	action.act = act
	action.can_be_unknown = can_be_unknown
	return action

static func unit_combo(
	unit_id: int,
	base_act: StringName,
	idx: int,
	total: int
) -> teVisualActionBase:
	var action := teVisualActionUnitCombo.new()
	action.unit_id = unit_id
	action.base_act = base_act
	action.idx = idx
	action.total = total
	return action

static func unit_move(unit_id: int, path: Array[Vector2i]) -> teVisualActionBase:
	var action := teVisualActionUnitMove.new()
	action.unit_id = unit_id
	action.path = path
	return action

static func unit_go_idle(unit_id: int) -> teVisualActionBase:
	var action := teVisualActionUnitGoIdle.new()
	action.unit_id = unit_id
	return action

static func unit_windup(
	unit_id: int,
	act: StringName
) -> teVisualActionBase:
	var action := teVisualActionUnitWindup.new()
	action.unit_id = unit_id
	action.act = act
	return action

static func unit_wait_winddown(
	unit_id: int,
	act: StringName
) -> teVisualActionBase:
	var action := teVisualActionUnitWaitWinddown.new()
	action.unit_id = unit_id
	action.act = act
	return action

static func unit_flash(unit_id: int, wait := false, time := 0.1, color := Color.WHITE) -> teVisualActionUnitFlash:
	var action := teVisualActionUnitFlash.new()
	action.unit_id = unit_id
	action.wait = wait
	action.time = time
	action.color = color
	return action

static func unit_shoot_projectile(
	shooter_id: int,
	target_id: int,
	projectile_uid: StringName,
	speed_multiplier: float = 1.0,
	trajectory_name: StringName = teVisualProjectileTrajectory.STRAIGHT
) -> teVisualActionUnitShootProjectile:
	var action := teVisualActionUnitShootProjectile.new()
	action.shooter_id = shooter_id
	action.target_id = target_id
	action.projectile_uid = projectile_uid
	action.speed_multiplier = speed_multiplier
	action.trajectory_name = trajectory_name
	return action

static func freeze_frame(duration: float = 0.08) -> teVisualActionFreezeFrame:
	var action := teVisualActionFreezeFrame.new()
	action.duration = duration
	return action

static func emit(events_buffer: teCombatEventsBuffer, state: teCombatState) -> teVisualActionEmitCombatEvents:
	var action := teVisualActionEmitCombatEvents.new()
	action.events = events_buffer.events.duplicate()
	action.updated_state = state.duplicate(true)
	return action

static func focus_unit(unit_id: int) -> teVisualActionFocusUnit:
	var action := teVisualActionFocusUnit.new()
	action.unit_id = unit_id
	return action

static func shoot_projectile(
	origin: Vector2,
	target: Vector2,
	projectile_uid: StringName,
	speed_multiplier: float = 1.0,
	trajectory_name: StringName = teVisualProjectileTrajectory.STRAIGHT
) -> teVisualActionShootProjectile:
	var action := teVisualActionShootProjectile.new()
	action.origin = origin
	action.target = target
	action.projectile_uid = projectile_uid
	action.speed_multiplier = speed_multiplier
	action.trajectory_name = trajectory_name
	return action

static func vfx_on_target(
	vfx_uid: StringName,
	target_id: int,
	params: Dictionary = {},
	socket: StringName = &"target"
) -> teVisualActionVfxOnTarget:
	var action := teVisualActionVfxOnTarget.new()
	action.vfx_uid = vfx_uid
	action.target_unit_id = target_id
	action.params = params
	action.socket = socket
	return action

static func collect_sub_actions(actions: Array) -> Array[teVisualActionBase]:
	var sub_actions: Array[teVisualActionBase] = []
	var actions_number := actions.size()
	sub_actions.resize(actions_number)
	for idx in range(actions_number):
		sub_actions[idx] = actions[idx]
	return sub_actions
