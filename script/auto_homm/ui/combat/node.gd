class_name teCombatUI extends Node


@export var combat: teCombat
@export var board: teBoardVisual
@export var markers: teCombatUiMarkers


func sync_units(combat_state: teCombatState):
	markers.sync(combat_state)


func _on_combat_started(initial_state: teCombatState):
	sync_units(initial_state)


func _on_combat_event(event: teCombatEventBase, state: teCombatState):
	if event is teCombatEventUnitDamaged:
		if state.has_unit(event.unit_id):
			markers.unit_set_hp(event.unit_id, state.unit(event.unit_id).hp_left())
	if event is teCombatEventManaGained or event is teCombatEventManaSpent:
		markers.unit_set_mana(event.unit_id, state.unit(event.unit_id).mana_collected)
	if event is teCombatEventUnitDied:
		markers.unit_remove_marker(event.unit_id)
