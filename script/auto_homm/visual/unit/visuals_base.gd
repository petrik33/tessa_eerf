@abstract
class_name teUnitVisualsBase extends Node2D


@export var node_to_glow: Node2D


func play_act(act_name: StringName, speed_scale: float):
	if is_acting():
		stop_acting()
	act(act_name, speed_scale)
	winddown()

func play_windup(act_name: StringName, speed_scale: float):
	if is_acting():
		stop_acting()
	act(act_name, speed_scale)
	windup(act_name)
	if not windup_finished():
		await windup_signal()
	winddown()

func play_combo(base_act: StringName, speed_scale: float, idx: int, total: int):
	if idx == 0:
		act(combo_act_name(base_act, total), speed_scale)
	windup(combo_windup_name(base_act, idx))
	if not windup_finished():
		await windup_signal()
	if idx == total -1:
		winddown()

func knows_combo(base_act: StringName, total: int) -> bool:
	return knows_act(combo_act_name(base_act, total))

func knows_windup(act_name: StringName) -> bool:
	return knows_act(act_name)


@abstract func face(angle: float)
@abstract func act(act_name: StringName, speed_scale: float)
@abstract func windup(act_name: StringName)
@abstract func winddown()
@abstract func stop_acting()

@abstract func knows_act(act_name: StringName) -> bool

@abstract func act_duration(act_name: StringName) -> float
@abstract func windup_duration(act_name: StringName) -> float
@abstract func winddown_duration(act_name: StringName) -> float
@abstract func combo_duration(base_act: StringName, idx: int, total: int)

@abstract func is_winding_up() -> bool
@abstract func is_acting() -> bool

@abstract func windup_finished() -> bool
@abstract func windup_signal() -> Signal
@abstract func act_finished_signal() -> Signal


func go_idle():
	pass

func start_moving():
	pass


func combo_act_name(base_act: StringName, total: int) -> StringName:
	return base_act + "_" + str(total)

func combo_windup_name(base_act: StringName, idx: int) -> StringName:
	if idx == 0:
		return base_act
	return base_act + "_" + str(idx + 1)
