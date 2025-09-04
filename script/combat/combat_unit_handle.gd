class_name CombatUnitHandle extends CombatHandle

@export var idx: int
@export var army_idx: int


func id() -> String:
	return "unit:%d_%d" % [idx, army_idx]


func _init(_idx := -1, _army_idx := -1) -> void:
	idx = _idx
	army_idx = _army_idx
