class_name teCombatEffectPoison extends teCombatEffectBase


@export var damage: float = 10.0


func hooks() -> Array[teCombatEffects.Hook]:
	return [teCombatEffects.Hook.TURN_START]


func on_hook(unit_id: int, hook: teCombatEffects.Hook, runtime: teCombatRuntime, state: teCombatState, resolved: teCombatResolvedAction):
	resolved.schedule(teCombatActions.damage(unit_id, teCombatDamage.TYPE.MAGICAL, damage))
