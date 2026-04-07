class_name teVisualFreezeSystem extends Node


signal unfrozen()


@export var freeze_timer: Timer


var initial_time_scale: float


func _exit_tree() -> void:
	unfreeze()


func unfreeze():
	freeze_timer.stop()
	_on_freeze_timer_timeout()


func freeze_frame(time_sec: float, time_scale: float) -> Signal:
	initial_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	freeze_timer.start(time_sec)
	return unfrozen


func _on_freeze_timer_timeout():
	Engine.time_scale = initial_time_scale
	unfrozen.emit()
