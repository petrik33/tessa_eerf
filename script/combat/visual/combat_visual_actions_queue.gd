class_name CombatVisualActionsQueue extends Resource

@export var actions: Array[CombatVisualActionBase]


func push_back(action: CombatVisualActionBase):
	actions.push_back(action)


func _init(_actions: Array[CombatVisualActionBase] = []):
	actions = _actions
