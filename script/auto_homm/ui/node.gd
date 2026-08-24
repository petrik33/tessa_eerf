class_name teUI extends Node


@export var board: teBoardVisual
@export var combat: teCombatUI


func set_setup_mode():
	combat.deactivate()


func set_combat_mode(initial_state: teCombatState):
	combat.activate(initial_state)


func set_potential_combat_state(state: teCombatState):
	combat.sync_units(state)
