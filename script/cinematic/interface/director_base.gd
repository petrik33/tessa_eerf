@abstract
class_name CinematicDirectorBase extends Node


signal combat_event(event: teCombatEventBase, state: teCombatState)


@abstract
func direct_take(action: teVisualActionBase, speed_scale := 1.0) -> CinematicTake

@abstract
func estimate_duration(action: teVisualActionBase) -> float
