class_name teVisualActions


func _init() -> void:
	Utils.assert_static_lib()


static func parallel(... actions: Array) -> teVisualActionBase:
	var action := teVisualActionParallel.new()
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action

static func sub_sequence(... actions: Array) -> teVisualActionBase:
	var action := teVisualActionSubSequence.new()
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action

static func unit_act(unit_id: int, act: StringName, go_idle := true) -> teVisualActionBase:
	var action := teVisualActionUnitAct.new()
	action.unit_id = unit_id
	action.act = act
	action.go_idle = go_idle
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

static func wait_unit_windup(unit_id: int, act: StringName) -> teVisualActionBase:
	var action := teVisualActionUnitWindup.new()
	action.unit_id = unit_id
	action.act = act
	return action

static func unit_windup_sequence(
	windup_act: teVisualActionUnitAct,
	on_windup: teVisualActionBase
) -> teVisualActionBase:
	return parallel(
		windup_act,
		sub_sequence(wait_unit_windup(windup_act.unit_id, windup_act.act), on_windup)
	)

static func freeze_frame(duration: float = 0.08) -> teVisualActionFreezeFrame:
	var action := teVisualActionFreezeFrame.new()
	action.duration = duration
	return action

static func emit(event: teCombatEventBase) -> teVisualActionEmitCombatEvent:
	var action := teVisualActionEmitCombatEvent.new()
	action.event = event
	return action

static func emit_all(events: Array[teCombatEventBase]) -> teVisualActionBase:
	var action := teVisualActionParallel.new()
	for event in events:
		action.actions.push_back(emit(event))
	return action

static func focus_unit(unit_id: int) -> teVisualActionFocusUnit:
	var action := teVisualActionFocusUnit.new()
	action.unit_id = unit_id
	return action

static func unit_flash(unit_id: int, time := 0.1, color := Color.WHITE) -> teVisualActionUnitFlash:
	var action := teVisualActionUnitFlash.new()
	action.unit_id = unit_id
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


static func unit_die(unit_id: int) -> teVisualActionUnitDie:
	var action := teVisualActionUnitDie.new()
	action.unit_id = unit_id
	return action
