class_name teCombatRules extends Resource


func initialize(setup: teCombatSetup) -> teCombatState:
	return null


func progress(
	state: teCombatState,
	services: teCombatServices
) -> teCombatCommandBase:
	return null


func process(
	state: teCombatState,
	command: teCombatCommandBase,
	services: teCombatServices
) -> teCombatEventLog:
	return null
