class_name teCombat extends Node


#signal hero_turn_started()
signal started(state: teCombatState)
signal turn_finished(log: teCombatEventLog)
signal finished(state: teCombatState)


@export var max_steps := 35
@export var turn_timer: Timer


var rules: teCombatRules
var services: teCombatServices


var initial_state: teCombatState
var prev_state: teCombatState
var current_state: teCombatState
var turn_history: teCombatTurnHistory


func read_state() -> teCombatState:
	return current_state if is_active() else prev_state


func turns_made() -> int:
	var number := turn_history.number()
	return number - 1 if number > 0 else 0 # Turn Zero doesn't count


func is_active() -> bool:
	return current_state != null


func start(_initial_state: teCombatState, _rules: teCombatRules, _services: teCombatServices):
	rules = _rules
	services = _services
	initial_state = _initial_state.duplicate()
	current_state = _initial_state.duplicate()
	prev_state = null
	turn_history = teCombatTurnHistory.new()
	
	started.emit(current_state)
	var turn_zero := rules.prepare(current_state, services)
	_take_turn(turn_zero)
	try_take_next_turn()


func restart():
	if initial_state == null:
		return
	if is_active():
		stop()
	start(initial_state, rules, services)


func stop():
	turn_timer.stop()
	prev_state = current_state
	current_state = null


func try_take_next_turn() -> bool:
	if not is_active():
		return false
	if rules.is_finished(current_state) or turns_made() >= max_steps:
		finished.emit(current_state)
		stop()
		return false
	var next_command := rules.progress(current_state, services)
	var turn_log := rules.process(current_state, next_command, services)
	_take_turn(turn_log)
	turn_timer.start()
	return true


func _take_turn(turn_log: teCombatEventLog):
	prev_state = current_state.duplicate(true)
	current_state.update(turn_log)
	turn_history.turns.append(turn_log)
	turn_finished.emit(turn_log)


func _on_timer_timeout():
	try_take_next_turn()
