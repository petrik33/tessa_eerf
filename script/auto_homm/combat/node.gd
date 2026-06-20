class_name teCombat extends Node


#signal hero_turn_started()
signal started(first_state: teCombatState)
signal action_taken(state: teCombatState, resolved: teCombatResolvedAction)
signal finished(final_state: teCombatState)


@export var turn_timer: Timer


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
	_process_command(teCombatCommands.start_combat())


func next_step():
	if not is_active():
		return
	_process_command(next_command())


func next_command() -> teCombatCommandBase:
	if rules.is_hero_turn(state):
		return teCombatCommands.skip_hero_turn()
	else:
		return rules.auto_command(runtime, state)


func stop():
	if not is_active():
		return
	turn_timer.stop()
	runtime = null
	finished.emit(state)
	state = null


func restart():
	if initial_state == null:
		return
	start(initial_state, rules)


func _process_command(command: teCombatCommandBase):
	var expanded := rules.expand(runtime, state, command)
	if not expanded.is_valid():
		turn_timer.start()
		return
	_take_scheduled(expanded.actions)
	if rules.is_finished(state):
		stop()
		return
	turn_timer.start()


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


func _on_timer_timeout():
	next_step()
