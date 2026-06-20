@abstract
class_name teVisualDirectorBase extends Node


signal take_started(take: teVisualTake)
signal take_cut(take: teVisualTake)


@abstract
func direct_take(action: teVisualActionBase, speed_scale := 1.0) -> teVisualTake

@abstract
func estimate_duration(action: teVisualActionBase) -> float
