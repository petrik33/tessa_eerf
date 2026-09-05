class_name teMoviePlayback extends Node


signal sequence_started(
	sequence: teVisualSequence,
	speed_scale: float,
	initial_estimated_time_sec: float
)

signal sequence_finished()


@export var director: teVisualDirectorBase
@export var scheduler: teVisualScheduler

@export var deadline_timer: Timer
@export var deadline_threshold_sec: float = 0.25
@export var deadlines_on := true
@export var slow_down_on := false

@export var custom_speed_scale := 1.0
@export var custom_speed_scale_on := false


var current_track_id: int = -1
var sequence_queue: Array[teVisualSequence]


func start():
	if is_playing():
		return
	_playing = true
	scheduler.track_finished.connect(_on_track_finished)
	if not sequence_queue.is_empty():
		_play_next_sequence()


func stop():
	if not is_playing():
		return
	if not is_idle():
		deadline_timer.stop()
		scheduler.stop(current_track_id)
		current_track_id = -1
	scheduler.track_finished.disconnect(_on_track_finished)
	scheduler.clear()
	_playing = false


func is_playing() -> bool:
	return _playing


func is_idle() -> bool:
	return current_track_id == -1


func is_waiting() -> bool:
	return is_playing() and is_idle()


func clear_queue():
	sequence_queue.clear()


func enqueue(sequence: teVisualSequence):
	sequence_queue.push_back(sequence)
	if is_waiting():
		_play_next_sequence()


func queue_empty() -> bool:
	return sequence_queue.is_empty()


var _playing: bool


func _play_next_sequence():
	if queue_empty():
		return
	var sequence: teVisualSequence = sequence_queue.pop_front()
	var estimated_time_sec := scheduler.estimate_duration(director, sequence.root_action)
	var speed_scale = _calc_track_speed_scale(estimated_time_sec, sequence.timeout_sec)
	current_track_id = scheduler.schedule(director, sequence.root_action, speed_scale)
	if current_track_id == -1:
		_play_next_sequence()
		return
	if deadlines_on:
		deadline_timer.start(sequence.timeout_sec + deadline_threshold_sec)
	sequence_started.emit(sequence, speed_scale, estimated_time_sec)
	scheduler.start(current_track_id)


func _on_track_finished(_track: teVisualTrackBase, id: int):
	if id == current_track_id:
		deadline_timer.stop()
		_finish_sequence()


func _on_deadline_timeout():
	print("Warning! Deadline timeout")
	scheduler.stop(current_track_id)
	_finish_sequence()


func _finish_sequence():
	current_track_id = -1
	sequence_finished.emit()
	_play_next_sequence()


func _calc_track_speed_scale(estimated_time_sec: float, sequence_timeout_sec: float) -> float:
	if custom_speed_scale_on:
		return custom_speed_scale
	if is_zero_approx(estimated_time_sec):
		return 1.0
	if is_zero_approx(sequence_timeout_sec):
		return 1.0
	var estimated_scale = estimated_time_sec / sequence_timeout_sec
	if slow_down_on:
		return estimated_scale
	else:
		return max(estimated_scale, 1.0)
