class_name teCombatSimulation extends RefCounted


var prev_state: teCombatState
var current_state: teCombatState
var services: teCombatServices
var rules: teCombatRules
var seed: int = 42
var turn_history: Array[teCombatEventLog] = []


func progress() -> teCombatEventLog:
	var next_command := rules.progress(current_state, services)
	var turn_log := rules.process(current_state, next_command, services)
	prev_state = current_state.duplicate(true)
	current_state.update(turn_log)
	turn_history.append(turn_log)
	return turn_log
	
