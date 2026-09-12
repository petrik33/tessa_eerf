class_name teCombatSkill extends Resource


@export var cast: teCombatSkillCastBase
@export var targeting_profile: teCombatTargetingProfile
@export var ends_turn: bool = true


func resolve(
	target: teCombatTargetBase,
	state: teCombatState,
	runtime: teCombatRuntime,
	resolved: teCombatResolvedAction
):
	if not teCombatTargeting.target_fits_mode(target, cast.targeting_mode()):
		return
	cast.resolve(target, state, runtime, resolved)
