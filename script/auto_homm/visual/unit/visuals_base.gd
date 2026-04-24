@abstract
class_name teUnitVisualsBase extends Node2D


@export var node_to_glow: Node2D


@abstract func play_act(act_name: StringName, speed_scale: float)
@abstract func knows_act(act_name: StringName) -> bool
@abstract func act_duration(act_name: StringName) -> float
@abstract func is_winding_up(act_name: StringName) -> bool
@abstract func windup_finished(act_name: StringName) -> bool
@abstract func windup_signal(act_name: StringName) -> Signal


func go_idle():
	pass

func start_moving():
	pass
