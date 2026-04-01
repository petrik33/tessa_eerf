class_name teCombatRuntime extends RefCounted


signal updated(event: teCombatEventBase)


var state: teCombatState
var turn_history: teCombatTurnHistory
var services: teCombatServices

var _current_turn: teCombatTurnLog


func _init(initial_state: teCombatState):
	state = initial_state.duplicate()
	services = teCombatServices.new(state)
	turn_history = teCombatTurnHistory.new()


func begin_turn():
	_current_turn = teCombatTurnLog.new()


func apply(event: teCombatEventBase):
	assert(_current_turn != null, "New turn not started yet")
	_current_turn.events.append(event)
	state.apply_event(event)
	updated.emit(event)


func end_turn():
	turn_history.turns.append(_current_turn)
	_current_turn = null
