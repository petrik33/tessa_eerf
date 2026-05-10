class_name teCombatUnitState extends Resource


@export var hp_spent: int = 0
@export var mana_collected: int = 0
@export var initiative_progress := 0.0
@export var stats: teUnitStats
@export var hex: Vector2i
@export var skill: teCombatUnitSkill
@export var attack_targeting: teCombatTargeting.Attack
@export var definition_uid: StringName


func hp_left() -> int:
	return stats.max_hp - hp_spent


func can_cast() -> bool:
	return skill != null and mana_collected >= stats.required_mana


func is_alive() -> bool:
	return hp_left() > 0


func in_attack_range(target: teCombatUnitState) -> bool:
	return HexMath.distance(hex, target.hex) <= stats.attack_range
