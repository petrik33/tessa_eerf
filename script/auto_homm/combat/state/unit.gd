class_name teCombatUnitState extends Resource


@export var hp_spent: int = 0
@export var mana_collected: int = 0
@export var initiative_progress := 0.0
@export var stats: teUnitStats
@export var hex: Vector2i
@export var definition_uid: StringName


func hp_left() -> int:
	return stats.max_hp - hp_spent


func is_alive() -> bool:
	return hp_left() > 0
