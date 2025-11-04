class_name CombatUiHud extends Control


@export var turn_queue: CombatUiTurnQueue


func update(state: CombatState):
	turn_queue.update(state)
