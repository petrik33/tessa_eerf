class_name teCombatEventsBuffer extends Resource


@export var events: Array[teCombatEventBase] = []


func append(event: teCombatEventBase):
	events.push_back(event)
