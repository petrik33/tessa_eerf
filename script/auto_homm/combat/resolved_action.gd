class_name teCombatResolvedAction extends Resource


var action: teCombatActionBase
var context: Context
var emitted_events: teCombatEventsBuffer
var scheduled_actions: teCombatScheduledActionsBuffer


func _init(_action: teCombatActionBase, _context: Context) -> void:
	action = _action
	context = _context
	emitted_events = teCombatEventsBuffer.new()
	scheduled_actions = teCombatScheduledActionsBuffer.new()


func events_to_emit() -> Array[teCombatEventBase]:
	return emitted_events.events


func actions_to_resolve() -> teCombatScheduledActionsBuffer:
	return scheduled_actions


func emit(event: teCombatEventBase):
	emitted_events.append(event)


func schedule(action: teCombatActionBase, action_context: Context = null):
	scheduled_actions.insert(action, action_context)


func delay(action: teCombatActionBase, action_context: Context = null):
	scheduled_actions.append(action, action_context)


func is_valid() -> bool:
	return action != null


static func unresolved() -> teCombatResolvedAction:
	return teCombatResolvedAction.new(null, null)
