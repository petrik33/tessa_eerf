class_name teCombatEffects


func _init() -> void:
	Utils.assert_static_lib()


enum Hook {
	TURN_START,
	UNIT_MOVED,
	DAMAGE_TAKEN,
	ATTACK,
	DAMAGE_DEALT
}


enum Duration {
	TURNS,
	ATTACKS,
	HITS,
	USAGES,
	ALWAYS
}


const POISON := &"POISON"


static func get_common_effect_name(effect: teCombatEffectBase) -> StringName:
	if effect is teCombatEffectPoison:
		return POISON
	return ""


static func apply_on_hook(
	hook: teCombatEffects.Hook,
	unit_id: int,
	runtime: teCombatRuntime,
	state: teCombatState,
	resolved: teCombatResolvedAction
):
	var unit := state.unit(unit_id)
	for effect_id in unit.effects:
		var inst := unit.effects[effect_id]
		if not inst.effect.hooks().has(hook):
			continue
		inst.effect.on_hook(unit_id, hook, runtime, state, resolved)
		if inst.duration == Duration.USAGES:
			consume(unit_id, effect_id, runtime, state, resolved)


static func consume_with_duration(
	duration: teCombatEffects.Duration,
	unit_id: int,
	runtime: teCombatRuntime,
	state: teCombatState,
	resolved: teCombatResolvedAction
):
	var unit := state.unit(unit_id)
	for effect_id in unit.effects:
		var inst := unit.effects[effect_id]
		if inst.duration != duration:
			continue
		consume(unit_id, effect_id, runtime, state, resolved)


static func consume(
	unit_id: int,
	effect_id: int,
	runtime: teCombatRuntime,
	state: teCombatState,
	resolved: teCombatResolvedAction
):
	resolved.emit(teCombatEvents.effect_consumed(unit_id, effect_id))
	if state.unit(unit_id).effects[effect_id].charges_left == 1:
		resolved.emit(teCombatEvents.effect_finished(unit_id, effect_id))


static func instance(
	effect: teCombatEffectBase,
	charges: int,
	duration: teCombatEffects.Duration
) -> teCombatEffectInstance:
	var inst := teCombatEffectInstance.new()
	inst.effect = effect
	inst.charges_left = charges
	inst.duration = duration
	return inst
