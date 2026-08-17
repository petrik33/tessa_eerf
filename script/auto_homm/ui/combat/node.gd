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
		if state.has_unit(event.damage.target_unit_id):
			markers.unit_damage(event.damage.target_unit_id, event.damage)
	if event is teCombatEventManaGained:
		markers.unit_gain_mana(event.unit_id, event.mana)
	if event is teCombatEventManaSpent:
		markers.unit_spend_mana(event.unit_id, event.amount)
	if event is teCombatEventUnitDied:
		markers.unit_remove_marker(event.unit_id)
	if event is teCombatEventEffectApplied or event is teCombatEventEffectConsumed:
		markers.unit_set_effects(event.unit_id, state.unit(event.unit_id).effects)
	if event is teCombatEventInitiativeTaken:
		markers.unit_set_active(event.unit_id, true)
	if event is teCombatEventInitiativeProgressed:
		markers.unit_set_active(state.initiative_holder_id, false)
