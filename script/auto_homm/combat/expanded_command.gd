class_name teCombatExpandedCommand extends Resource


var command: teCombatCommandBase
var actions: Array[teCombatActionBase] = []
var context: Array[Context] = []


func _init(_command: teCombatCommandBase):
	command = _command


func append(action: teCombatActionBase, action_context: Context = null):
	actions.push_back(action)
	context.push_back(action_context)


func is_valid() -> bool:
	return command != null


func invalidate():
	command = null


static func invalid() -> teCombatExpandedCommand:
	return teCombatExpandedCommand.new(null)
