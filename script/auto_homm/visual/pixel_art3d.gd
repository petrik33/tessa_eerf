class_name teVisualPixelArt3d extends Node


@export var shadow_cast: PixelArt3dShadowCast


func sync(state: teCombatState):
	shadow_cast.sync_units(state)


func _on_combat_event(event: teCombatEventBase, state: teCombatState):
	if event is teCombatEventUnitDied:
		shadow_cast.destroy_shadow_mesh(event.unit_id)
