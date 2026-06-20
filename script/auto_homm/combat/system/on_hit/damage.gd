class_name teCombatOnHitEffectDealDamage extends teCombatOnHitEffectBase


@export var damage: float
@export var type: teCombatDamage.TYPE


func apply(
	unit_id: int,
	damage: teCombatDamageInstance,
	runtime: teCombatRuntime,
	state: teCombatState,
	resolved: teCombatResolvedAction
):
	pass
