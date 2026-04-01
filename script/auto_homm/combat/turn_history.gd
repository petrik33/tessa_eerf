class_name teCombatTurnHistory extends Resource


@export var turns: Array[teCombatTurnLog] = []


func current_turn() -> teCombatTurnLog:
	return turns.back()

func number() -> int:
	return turns.size()

func record_next_turn():
	turns.push_back(teCombatTurnLog.new())

func record(event: teCombatEventBase):
	current_turn().events.push_back(event)
