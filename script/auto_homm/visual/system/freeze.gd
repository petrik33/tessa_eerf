class_name teVisualFreezeSystem extends Node


signal unfrozen()


@export var freeze_timer: Timer
@export var freeze_tip: Control
@export var tip_on := false


var initial_time_scale: float


func _exit_tree() -> void:
	unfreeze()


func unfreeze():
	freeze_timer.stop()
	_on_freeze_timer_timeout()


func stop_frame(time_sec: float):
	freeze_frame(time_sec, 0.0)


func freeze_frame(time_sec: float, time_scale: float):
	initial_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	freeze_timer.start(time_sec)
	if tip_on:
		freeze_tip.visible = true


func _on_freeze_timer_timeout():
	if tip_on:
		freeze_tip.visible = false
	Engine.time_scale = initial_time_scale
	unfrozen.emit()
