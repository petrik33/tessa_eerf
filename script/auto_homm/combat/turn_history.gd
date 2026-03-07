class_name teCombatTurnHistory extends Resource


@export var turns: Array[teCombatEventLog] = []


func number() -> int:
	return turns.size()
