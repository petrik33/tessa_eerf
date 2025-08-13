class_name CombatActionRemoveFromTurnQueue extends CombatActionBase

@export var turn_queue_idx: int

func _init(_turn_queue_idx: int = -1):
	turn_queue_idx = _turn_queue_idx
