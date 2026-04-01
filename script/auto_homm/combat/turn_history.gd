class_name teCombatTurnHistory extends Resource


@export var turns: Array[teCombatTurnLog] = []


func number() -> int:
	return turns.size()
