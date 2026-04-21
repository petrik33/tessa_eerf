class_name teCombatExpandedCommand extends Resource


var command: teCombatCommandBase
var actions: Array[teCombatActionBase] = []


func _init(_command: teCombatCommandBase):
	command = _command


func append(action: teCombatActionBase):
	actions.push_back(action)


func is_valid() -> bool:
	return command != null


static func invalid() -> teCombatExpandedCommand:
	return teCombatExpandedCommand.new(null)
