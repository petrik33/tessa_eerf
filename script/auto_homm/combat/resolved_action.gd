class_name teCombatResolvedAction extends Resource


var action: teCombatActionBase
var context: Context
var events_buffer: teCombatEventsBuffer


func _init(_action: teCombatActionBase, _context: Context) -> void:
	action = _action
	context = _context
	events_buffer = teCombatEventsBuffer.new()


func push_back(event: teCombatEventBase):
	events_buffer.append(event)


func is_valid() -> bool:
	return action != null


static func unresolved() -> teCombatResolvedAction:
	return teCombatResolvedAction.new(null, null)
