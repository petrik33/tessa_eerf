class_name CombatUnitHandle extends Resource

@export var idx: int
@export var army_idx: int


func _init(_idx := -1, _army_idx := -1) -> void:
	idx = _idx
	army_idx = _army_idx


func is_equal(other: CombatUnitHandle) -> bool:
	return other.idx == idx and other.army_idx == army_idx
