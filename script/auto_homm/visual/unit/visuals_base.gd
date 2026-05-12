@abstract
class_name teUnitVisualsBase extends Node2D


@export var node_to_glow: Node2D


@abstract func face(angle: float)
@abstract func play_act(act_name: StringName, speed_scale: float, go_idle_then: bool)
@abstract func windup(act_name: StringName)
@abstract func knows_act(act_name: StringName) -> bool
@abstract func act_duration(act_name: StringName) -> float
@abstract func is_winding_up() -> bool
@abstract func is_acting() -> bool
@abstract func windup_finished() -> bool
@abstract func windup_signal() -> Signal


func go_idle():
	pass

func start_moving():
	pass
