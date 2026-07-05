class_name teVisualPixelArt3d extends Node


@export var shadow_cast: PixelArt3dShadowCast


func sync(state: teCombatState):
	shadow_cast.sync_units(state)
