class_name CombatArmyHandle extends Resource

@export var idx: int

func _init(_idx: int = -1) -> void:
	idx = _idx

func is_equal(other: CombatArmyHandle) -> bool:
	return idx == other.idx
