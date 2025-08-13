class_name CombatUnitState extends Resource

@export var data: UnitData
@export var placement: Vector2i
@export var side_idx: int

func stats() -> UnitCombatStats:
	return data.combat_stats

func is_an_ally(ally_side_idx: int) -> bool:
	return side_idx == ally_side_idx

func is_an_enemy(ally_side_idx: int) -> bool:
	return ally_side_idx != side_idx

func _init(_data: UnitData = null, _placement := Vector2i.ZERO, _side_idx := -1) -> void:
	data = _data
	placement = _placement
	side_idx = _side_idx
