class_name teCombatDamage


func _init() -> void:
	Utils.assert_static_lib()


enum TYPE {
	PHYSICAL,
	MAGICAL,
	TRUE
}


const SOURCE_PREFIX_EFFECT := "EFFECT_"


static func source_is_effect(source: StringName) -> bool:
	return source.contains(SOURCE_PREFIX_EFFECT)


static func source_effect(effect_name: StringName) -> StringName:
	return SOURCE_PREFIX_EFFECT + effect_name


static func source_what_effect(source: StringName) -> StringName:
	return source.get_slice(SOURCE_PREFIX_EFFECT, 1)


static func instance(
	target_unit_id: int,
	type: TYPE,
	base_amount: float,
	source: StringName = "",
	tags := TagSet.new()
) -> teCombatDamageInstance:
	var inst := teCombatDamageInstance.new()
	inst.base_amount = base_amount
	inst.target_unit_id = target_unit_id
	inst.type = type
	inst.source = source
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
