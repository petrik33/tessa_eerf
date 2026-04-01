class_name teCombatUI extends Node


@export var combat: teCombat
@export var board: teBoardVisual
@export var marker_scene: PackedScene


func sync_units(combat_state: teCombatState):
	for unit_id in combat_state.all_units_id():
		sync_unit_hp(unit_id, combat_state)


func sync_unit_hp(unit_id: int, combat_state: teCombatState):
	var combat_unit := combat_state.unit(unit_id)
	var unit_view := board.get_unit(unit_id)
	unit_view.get_marker().set_hp(combat_unit.hp_left())


func _on_combat_started(initial_state: teCombatState):
	sync_units(initial_state)


func _on_combat_event(event: teCombatEventBase):
	if event is teCombatEventUnitAttacked:
		var unit_view := board.get_unit(event.unit_id)
		unit_view.get_marker().decrease_hp(event.damage)
