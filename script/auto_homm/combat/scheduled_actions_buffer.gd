class_name teCombatScheduledActionsBuffer extends Resource


@export var actions: Array[teCombatActionBase] = []
@export var context: Array[Context] = []


func size() -> int:
	return actions.size()


func insert(action: teCombatActionBase, action_context: Context = null):
	actions.insert(0, action)
	context.insert(0, action_context)


func append(action: teCombatActionBase, action_context: Context = null):
	actions.push_back(action)
	context.push_back(action_context)
