class_name teCombatDamage


func _init() -> void:
	Utils.assert_static_lib()


enum TYPE {
	PHYSICAL,
	MAGICAL,
	TRUE
}


static func instance(
	target_unit_id: int,
	source_unit_id: int,
	type: TYPE,
	base_amount: float,
	tags := TagSet.new()
) -> teCombatDamageInstance:
	var inst := teCombatDamageInstance.new()
	inst.base_amount = base_amount
	inst.target_unit_id = target_unit_id
	inst.source_unit_id = source_unit_id
	inst.type = type
	inst.tags = tags
	return inst


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
