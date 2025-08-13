class_name CombatActionMove extends CombatActionBase

@export var unit_idx: int
@export var path: Array[Vector2i]

func target_hex() -> Vector2i:
	return path[-1]

func _init(_unit_idx: int = -1, _path: Array[Vector2i] = []):
	unit_idx = _unit_idx
	path = _path
