@abstract
class_name teCombatEffectBase extends Resource


@abstract
func hooks() -> Array[teCombatEffects.Hook]

@abstract
func on_hook(unit_id: int, hook: teCombatEffects.Hook, runtime: teCombatRuntime, state: teCombatState, resolved: teCombatResolvedAction)
