class_name teCombatEffectCombo extends teCombatEffectBase


@export var hits: int = 3


func hooks() -> Array[teCombatEffects.Hook]:
	return [teCombatEffects.Hook.ATTACK]


func on_hook(unit_id: int, hook: teCombatEffects.Hook, runtime: teCombatRuntime, state: teCombatState, resolved: teCombatResolvedAction):
	assert(resolved.action is teCombatActionUnitAttack)
	var attack_action := resolved.action as teCombatActionUnitAttack
	resolved.context.add(teCombatContext.COMBO_HIT, 0)
	resolved.context.add(teCombatContext.COMBO_LENGTH, hits)
	for idx in range(hits - 1):
		var context := Context.new()
		context.add(teCombatContext.COMBO_HIT, idx + 1)
		context.add(teCombatContext.COMBO_LENGTH, hits)
		resolved.delay(teCombatActions.unit_attack(unit_id, attack_action.target_id), context)
