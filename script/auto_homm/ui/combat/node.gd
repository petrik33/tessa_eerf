class_name teCombatUI extends Node


@export var combat: teCombat
@export var board: teBoardVisual
@export var markers: teCombatUiMarkers


func sync_units(combat_state: teCombatState):
	markers.sync(combat_state)


func _on_combat_started(initial_state: teCombatState):
	sync_units(initial_state)


func _on_combat_event(event: teCombatEventBase):
	if event is teCombatEventUnitDamaged:
		markers.unit_update_hp(event.unit_id, -event.damage)
	if event is teCombatEventManaGained:
		markers.unit_update_mana(event.unit_id, event.mana)
	if event is teCombatEventUnitDied:
		markers.unit_remove_marker(event.unit_id)
