class_name teCombatActions


func _init() -> void:
	Utils.assert_static_lib()


static func attack(unit_id: int, target_id: int) -> teCombatActionAttack:
	var action := teCombatActionAttack.new()
	action.unit_id = unit_id
	action.target_id = target_id
	return action


static func move(unit_id: int, movement_path: teCombatMovementPath) -> teCombatActionMove:
	var action := teCombatActionMove.new()
	action.unit_id = unit_id
	action.path = movement_path
	return action


static func cast(unit_id: int, target: teCombatTargetBase) -> teCombatActionCastSkill:
	var action := teCombatActionCastSkill.new()
	action.unit_id = unit_id
	action.target = target
	return action


static func damage(
	target_unit_id: int,
	type: teCombatDamage.TYPE,
	base_amount: float,
	source: StringName = "",
	tags := TagSet.new()
) -> teCombatActionDamage:
	var action := teCombatActionDamage.new()
	action.instances = [teCombatDamage.instance(target_unit_id, type, base_amount, source, tags)]
	return action


static func multiple_damage(instances: Array[teCombatDamageInstance] = []) -> teCombatActionDamage:
	var action := teCombatActionDamage.new()
	action.instances = instances
	return action


static func initiative_advance() -> teCombatActionInitiativeAdvance:
	return teCombatActionInitiativeAdvance.new()


static func dodge_attack(unit_id: int) -> teCombatActionDodge:
	var action := teCombatActionDodge.new()
	action.unit_id = unit_id
	return action


static func apply_effect(
	effect: teCombatEffectBase,
	charges: int,
	duration: teCombatEffects.Duration,
	unit_id: int
) -> teCombatActionApplyEffect:
	var action := teCombatActionApplyEffect.new()
	action.effect = effect
	action.charges = charges
	action.duration = duration
	action.units = [unit_id]
	return action


static func apply_effects(
	effect: teCombatEffectBase,
	charges: int,
	duration: teCombatEffects.Duration,
	units_id: Array[int]
) -> teCombatActionApplyEffect:
	var action := teCombatActionApplyEffect.new()
	action.effect = effect
	action.charges = charges
	action.duration = duration
	action.units = units_id
	return action
