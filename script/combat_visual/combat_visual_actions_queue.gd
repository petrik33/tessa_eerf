class_name CombatVisualActionsQueue extends Resource

@export var actions: Array[CombatVisualActionBase]

func _init(_actions: Array[CombatVisualActionBase] = []):
	actions = _actions
	
func push_back(action: CombatVisualActionBase):
	actions.push_back(action)
