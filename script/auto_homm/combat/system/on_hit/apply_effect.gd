class_name teCombatOnHitEffectApplyEffect extends teCombatOnHitEffectBase


@export var effect: teCombatEffectBase
@export var charges: int
@export var duration: teCombatEffects.Duration


func apply(
	unit_id: int,
	damage: teCombatDamageInstance,
	runtime: teCombatRuntime,
	state: teCombatState,
	resolved: teCombatResolvedAction
):
	resolved.delay(teCombatActions.apply_effect(effect, charges, duration, damage.target_unit_id))
