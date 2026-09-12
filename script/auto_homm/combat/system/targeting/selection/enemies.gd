class_name teCombatTargetSelectionEnemies extends teCombatTargetSelectionBase


func first_target(state: teCombatState, runtime: teCombatRuntime, unit_id: int) -> teCombatTargetBase:
	var team_id = state.unit_team_id(unit_id)
	var enemies := state.enemies_id(team_id)
	return teCombatTargets.units(enemies)
