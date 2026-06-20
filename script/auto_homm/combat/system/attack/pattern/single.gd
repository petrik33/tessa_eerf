class_name teCombatAttackPatternSingle extends teCombatAttackPatternBase


func expand(
	attacker_id: int,
	primary_target_id: int,
	_runtime: teCombatRuntime,
	_state: teCombatState,
	expanded: teCombatExpandedCommand
):
	expanded.append(teCombatActions.unit_attack(attacker_id, primary_target_id))
