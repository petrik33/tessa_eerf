class_name teVisualActions


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func parallel(... actions: Array) -> teVisualActionBase:
	var action := teVisualActionParallel.new()
	action.actions = []
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action

static func sub_sequence(... actions: Array) -> teVisualActionBase:
	var action := teVisualActionSubSequence.new()
	action.actions = []
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action

static func unit_sequence(unit_id: int, ... acts: Array) -> teVisualActionBase:
	var action := teVisualActionUnitSequence.new()
	action.unit_id = unit_id
	for act in acts:
		action.acts.push_back(act)
	return action

static func wait_unit_windup(unit_id: int) -> teVisualActionBase:
	var action := teVisualActionUnitWindup.new()
	action.unit_id = unit_id
	return action

static func unit_windup_sequence(
	sequence: teVisualActionUnitSequence,
	on_windup: teVisualActionBase
) -> teVisualActionBase:
	return parallel(
		sequence,
		sub_sequence(wait_unit_windup(sequence.unit_id), on_windup)
	)

static func freeze_frame(duration: float = 0.08) -> teVisualActionFreezeFrame:
	var action := teVisualActionFreezeFrame.new()
	action.duration = duration
	return action

static func emit(event: teCombatEventBase) -> teVisualActionEmitCombatEvent:
	var action := teVisualActionEmitCombatEvent.new()
	action.event = event
	return action

static func focus_unit(unit_id: int) -> teVisualActionFocusUnit:
	var action := teVisualActionFocusUnit.new()
	action.unit_id = unit_id
	return action

static func unit_flash(unit_id: int, time := 1.0, color := Color.WHITE) -> teVisualActionUnitFlash:
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
	vfx_id: StringName,
	target_id: int,
	params: Dictionary = {},
	socket: StringName = &"target"
) -> teVisualActionVfxOnTarget:
	var action := teVisualActionVfxOnTarget.new()
	action.vfx_id = vfx_id
	action.target_unit_id = target_id
	action.params = params
	action.socket = socket
	return action


static func unit_die(unit_id: int) -> teVisualActionUnitDie:
	var action := teVisualActionUnitDie.new()
	action.unit_id = unit_id
	return action
