class_name teCombatSimulation extends RefCounted


var initial_state: teCombatState
var prev_state: teCombatState
var current_state: teCombatState
var turn_history := teTurnHistory.new()


func _init(_initial_state: teCombatState):
	initial_state = _initial_state
	current_state = _initial_state


func steps_made() -> int:
	return turn_history.number()


func progress(turn_log: teCombatEventLog):
	prev_state = current_state.duplicate(true)
	current_state.update(turn_log)
	turn_history.append(turn_log)


func finished() -> bool:
	return current_state.is_finished()
	
