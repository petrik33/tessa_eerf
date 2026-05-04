@abstract
class_name teVisualDirectorBase extends Node


@abstract
func direct_take(action: teVisualActionBase, speed_scale := 1.0) -> teVisualTake

@abstract
func estimate_duration(action: teVisualActionBase) -> float
