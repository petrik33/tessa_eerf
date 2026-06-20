class_name teCombatSkillApplyEffect extends teCombatSkillCastBase


@export var effect: teCombatEffectBase
@export var duration: teCombatEffects.Duration
@export var charges: int = 1


func resolve(
	target: teCombatTargetBase,
	_state: teCombatState,
	_runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
):
	var unit_target := target as teCombatTargetUnit
	resolved.schedule(teCombatActions.apply_effects(effect, charges, duration, unit_target.units_id))


func targeting_mode() -> teCombatTargeting.Mode:
	return teCombatTargeting.Mode.UNIT_OR_UNITS
