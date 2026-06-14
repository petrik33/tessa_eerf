class_name teCombatTargetUnit extends teCombatTargetBase


@export var units_id: Array[int]


func is_single() -> bool:
	return units_id.size() == 1


func single() -> int:
	return units_id[0]
