class_name teVisualCutter extends teVisualCutterBase


@export var uniform_time_sec: float = 1.5


func cut_time(action: teCombatActionBase) -> float:
	return uniform_time_sec
