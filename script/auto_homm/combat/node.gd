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
	step()


func step():
	if not is_active():
		return
	var command: teCombatCommandBase
	if rules.is_hero_turn(state):
		command = teCombatCommands.skip_hero_turn()
	else:
		_take(teCombatActions.initiative_advance())
		command = rules.auto_command(state)
	var expanded := rules.expand(runtime, state, command)
	if not expanded.is_valid():
		return
	for action in expanded.actions:
		runtime.enqueue(action)
	while not runtime.action_queue.is_empty():
		_take(runtime.action_queue.pop_front())
	if rules.is_finished(state):
		stop()
		return
	turn_timer.start()


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


func _take(action: teCombatActionBase):
	var resolved := rules.resolve(state, action)
	if not resolved.is_valid():
		return
	for event in resolved.events:
		state.update(event)
		runtime.update(event)
	action_taken.emit(state, resolved)


func _on_timer_timeout():
	step()
