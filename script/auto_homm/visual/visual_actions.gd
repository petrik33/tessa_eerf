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

static func emit(event: teCombatEventBase) -> teVisualActionCombatEventHappened:
	var action := teVisualActionCombatEventHappened.new()
	action.event = event
	return action
