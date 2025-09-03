class_name CombatActionMove extends CombatActionBase

@export var unit_handle: CombatUnitHandle
@export var path: Array[Vector2i]

func target_hex() -> Vector2i:
	return path[-1]

func _init(_unit_handle: CombatUnitHandle = null, _path: Array[Vector2i] = []):
	unit_handle = _unit_handle
	path = _path
