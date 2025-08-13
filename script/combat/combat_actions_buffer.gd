class_name CombatActionsBuffer extends Resource

@export var actions: Array[CombatActionBase]

func _init(_actions: Array[CombatActionBase] = []):
	actions = _actions
	
func push_back(action: CombatActionBase):
	actions.push_back(action)
