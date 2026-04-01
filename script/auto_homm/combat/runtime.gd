class_name teCombatRuntime extends RefCounted


signal updated(updated_state: teCombatState, event: teCombatEventBase)


var state: teCombatState
var services: teCombatServices


func _init(initial_state: teCombatState):
	state = initial_state.duplicate()
	services = teCombatServices.new(state)


func update(event: teCombatEventBase):
	state.apply_event(event)
	updated.emit(event)
