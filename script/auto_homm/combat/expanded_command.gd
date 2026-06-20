class_name teCombatExpandedCommand extends Resource


var command: teCombatCommandBase
var actions: teCombatScheduledActionsBuffer


func _init(_command: teCombatCommandBase):
	command = _command
	actions = teCombatScheduledActionsBuffer.new()


func append(action: teCombatActionBase, action_context: Context = Context.new()):
	actions.append(action, action_context)


func is_valid() -> bool:
	return command != null


func invalidate():
	command = null


static func invalid() -> teCombatExpandedCommand:
	return teCombatExpandedCommand.new(null)
