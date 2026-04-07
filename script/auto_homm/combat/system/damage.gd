class_name teCombatDamage


func _init() -> void:
	Utils.assert_static_lib()


static func calculate(
	combat: teCombatState,
	attacker: teCombatUnitState,
	target: teCombatUnitState
) -> int:
	return attacker.stats.attack_damage


static func is_lethal(
	combat: teCombatState,
	unit: teCombatUnitState,
	damage: int
) -> bool:
	return unit.hp_spent + damage > unit.stats.max_hp
