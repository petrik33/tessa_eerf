class_name teCombatUI extends Node


@export var director: CinematicDirectorBase
@export var markers: teCombatUiMarkers

@export var target_hex_renderer: HexFilledRenderer
@export var target_outline_colors: Dictionary[TargetOutline, Color]

@export var auto_target_hex_renderer: HexGridRendererBase


enum TargetOutline {
	HEAL,
	ATTACK,
	MOVE_AND_ATTACK,
	CAST
}


func outline_target_hex(grid: HexGridBase, target: TargetOutline):
	target_hex_renderer.grid = grid
	target_hex_renderer.hex_color = target_outline_colors[target]


func outline_auto_target_hex(grid: HexGridBase):
	auto_target_hex_renderer.grid = grid


func clear_outlines():
	target_hex_renderer.grid = null
	auto_target_hex_renderer.grid = null


func activate(state: teCombatState):
	markers.set_process(true)
	director.combat_event.connect(_on_combat_event)
	sync_units(state)


func deactivate():
	clear_outlines()
	markers.units_clear_active()
	director.combat_event.disconnect(_on_combat_event)
	markers.set_process(false)


func sync_units(combat_state: teCombatState):
	markers.sync(combat_state)


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
	if event is teCombatEventInitiativeReleased:
		markers.units_clear_active()
	if event is teCombatEventInitiativeTaken:
		markers.unit_set_active(event.unit_id, true)
