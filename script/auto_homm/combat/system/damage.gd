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
	type: TYPE,
	base_amount: float,
	tags := TagSet.new()
) -> teCombatDamageInstance:
	var inst := teCombatDamageInstance.new()
	inst.base_amount = base_amount
	inst.target_unit_id = target_unit_id
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
	damage: teCombatDamageInstance
) -> bool:
	var unit := combat.unit(damage.target_unit_id)
	return unit.hp_spent + damage.base_amount > unit.stats.max_hp
