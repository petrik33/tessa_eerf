class_name teCombatRuntime extends RefCounted


var services: teCombatServices
var action_queue: Array[teCombatActionBase]
var action_context_queue: Array[Context]


func _init(initial_state: teCombatState):
	services = teCombatServices.new(initial_state)


func update(event: teCombatEventBase):
	services.update(event)


func enqueue(action: teCombatActionBase, action_context: Context):
	action_queue.push_back(action)
	action_context_queue.push_back(action_context)
