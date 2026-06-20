class_name teCombatUnitDamage extends teCombatSkillCastBase


@export var modifier := 1.0
@export var type: teCombatDamage.TYPE


func resolve(
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
):
	var cast_target := target as teCombatTargetUnit
	var damage_amount := 7.0 * modifier # TODO: Replace with actual damage calc through stats
	var damage := teCombatActions.multiple_damage()
	for id in cast_target.units_id:
		damage.instances.append(teCombatDamage.instance(id, type, damage_amount))
	resolved.schedule(damage)


func targeting_mode() -> teCombatTargeting.Mode:
	return teCombatTargeting.Mode.UNIT_OR_UNITS
