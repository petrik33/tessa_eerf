class_name teCombatRuntime extends RefCounted


var services: teCombatServices
var action_queue: Array[teCombatActionBase]


func _init(initial_state: teCombatState):
	services = teCombatServices.new(initial_state)


func update(event: teCombatEventBase):
	services.update(event)


func enqueue(action: teCombatActionBase):
	action_queue.push_back(action)
