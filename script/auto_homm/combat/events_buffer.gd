class_name teCombatEventsBuffer extends Resource


@export var events: Array[teCombatEventBase] = []


func append(event: teCombatEventBase):
	events.push_back(event)


func has(cond: Callable) -> bool:
	return events.find_custom(cond) != -1


func find(cond: Callable) -> teCombatEventBase:
	var idx := events.find_custom(cond)
	if idx == -1:
		return null
	return events[idx]
