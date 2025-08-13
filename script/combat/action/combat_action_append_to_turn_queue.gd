class_name CombatActionAppendToTurnQueue extends CombatActionBase

@export var unit_idx: int

func _init(_unit_idx: int = -1) -> void:
	unit_idx = _unit_idx
