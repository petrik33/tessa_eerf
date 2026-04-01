class_name teCombat extends Node


#signal hero_turn_started()
signal started(first_state: teCombatState)
signal turn_started()
signal updated(state: teCombatState, event: teCombatEventBase)
signal turn_finished(log: teCombatTurnLog)
signal finished(final_state: teCombatState)


@export var max_steps := 35
@export var turn_timer: Timer


var rules: teCombatRules
var runtime: teCombatRuntime

var initial_state: teCombatState


func turns_made() -> int:
	var number := runtime.turn_history.number()
	return number - 1 if number > 0 else 0 # Turn Zero doesn't count


func is_active() -> bool:
	return runtime != null


func start(_initial_state: teCombatState, _rules: teCombatRules):
	rules = _rules
	initial_state = _initial_state.duplicate()
	runtime = teCombatRuntime.new(initial_state)
	started.emit(initial_state)
	rules.prepare(runtime)
	try_take_next_turn()


func restart():
	if initial_state == null:
		return
	if is_active():
		stop()
	start(initial_state, rules)


func stop():
	turn_timer.stop()
	runtime = null


func try_take_next_turn() -> bool:
	if not is_active():
		return false
	if rules.is_finished(runtime) or turns_made() >= max_steps:
		finished.emit(runtime.state)
		stop()
		return false
	turn_started.emit()
	var next_command := rules.progress(runtime)
	rules.process(runtime, next_command)
	turn_finished.emit()
	turn_timer.start()
	return true


func _on_runtime_updated(event: teCombatEventBase):
	updated.emit(runtime.state, event)


func _on_timer_timeout():
	try_take_next_turn()
