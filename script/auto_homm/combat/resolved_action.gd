class_name teCombatResolvedAction extends Resource


var action: teCombatActionBase
var context: Context
var events: Array[teCombatEventBase] = []


func _init(_action: teCombatActionBase, _context: Context) -> void:
	action = _action
	context = _context


func push_back(event: teCombatEventBase):
	events.push_back(event)


func is_valid() -> bool:
	return action != null


static func unresolved() -> teCombatResolvedAction:
	return teCombatResolvedAction.new(null, null)
