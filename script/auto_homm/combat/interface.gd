@abstract
class_name teCombatBase extends Node


signal started(first_state: teCombatState)
signal action_taken(state: teCombatState, resolved: teCombatResolvedAction)
signal finished(final_state: teCombatState)


var rules: teCombatRules
var runtime: teCombatRuntime
var state: teCombatState
var initial_state: teCombatState


func is_active() -> bool:
	return runtime != null


func start(_initial_state: teCombatState, _rules: teCombatRules):
	if is_active():
		stop()
	rules = _rules
	initial_state = _initial_state.duplicate()
	state = initial_state.duplicate()
	runtime = teCombatRuntime.new(initial_state)
	started.emit(initial_state)
	_try_process_command(teCombatCommands.start_combat())
	_next_step()


func stop():
	if not is_active():
		return
	runtime = null
	state = null


func restart():
	if initial_state == null:
		return
	start(initial_state, rules)


@abstract func _next_step()


func _finish():
	finished.emit(state)
	stop()


func _try_process_command(command: teCombatCommandBase) -> bool:
	var expanded := rules.expand(runtime, state, command)
	if not expanded.is_valid():
		return false
	_take_scheduled(expanded.actions)
	return true


func _take_scheduled(scheduled: teCombatScheduledActionsBuffer):
	for idx in range(scheduled.size()):
		var action := scheduled.actions[idx]
		var context := scheduled.context[idx]
		_take(action, context)


func _take(action: teCombatActionBase, context: Context = null):
	var resolved := rules.resolve(state, runtime, action, context)
	if not resolved.is_valid():
		return
	for event in resolved.events_to_emit():
		state.update(event)
		runtime.update(event)
	action_taken.emit(state, resolved)
	_take_scheduled(resolved.actions_to_resolve())
