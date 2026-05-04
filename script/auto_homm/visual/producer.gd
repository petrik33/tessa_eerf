class_name teVisualProducer extends Node


signal sequence_finished()


@export var director: teVisualDirectorBase
@export var deadline_timer: Timer
@export var deadline_threshold_sec: float = 0.25


var current_track: teVisualTrackBase
var sequence_queue: Array[teVisualSequence]
var is_filming: bool


func start():
	if is_filming:
		return
	is_filming = true
	if not sequence_queue.is_empty():
		_play_next_track()


func stop():
	if not is_filming:
		return
	is_filming = false
	clear_queue()
	if is_playing():
		deadline_timer.stop()
		current_track.finished.disconnect(_on_current_track_finished)
		current_track.stop()
		current_track = null


func is_playing() -> bool:
	return current_track != null


func is_waiting() -> bool:
	return is_filming and not is_playing()


func clear_queue():
	sequence_queue.clear()


func enqueue(action: teVisualActionBase, time_sec: float):
	sequence_queue.push_back(teVisualSequence.new(action, time_sec))
	if is_waiting():
		_play_next_track()


func queue_empty() -> bool:
	return sequence_queue.is_empty()


func track(action: teVisualActionBase, speed_scale: float) -> teVisualTrackBase:
	if action is teVisualActionParallel:
		return teVisualTracks.parallel(_map_tracks(action.actions, speed_scale))
	if action is teVisualActionSubSequence:
		return teVisualTracks.sub_sequence(_map_tracks(action.actions, speed_scale))
	return teVisualTracks.take(director, action, speed_scale)


func estimate_duration(action: teVisualActionBase) -> float:
	if action is teVisualActionParallel:
		var max_duration := 0.0
		for sub_action in action.actions:
			max_duration = max(max_duration, estimate_duration(sub_action))
		return max_duration
	if action is teVisualActionSubSequence:
		var total_duration := 0.0
		for sub_action in action.actions:
			total_duration += estimate_duration(sub_action)
		return total_duration
	return director.estimate_duration(action)


func _play_next_track():
	var sequence: teVisualSequence = sequence_queue.pop_front()
	var estimated_time_sec := estimate_duration(sequence.root_action)
	var speed_scale = max(estimated_time_sec / sequence.timeout_sec, 1.0)
	current_track = track(sequence.root_action, speed_scale)
	current_track.finished.connect(_on_current_track_finished, CONNECT_ONE_SHOT)
	deadline_timer.start(sequence.timeout_sec + deadline_threshold_sec)
	current_track.start()


func _on_current_track_finished():
	print("Track finished")
	deadline_timer.stop()
	_finish_sequence()


func _on_deadline_timeout():
	print("Warning! Deadline timeout")
	current_track.finished.disconnect(_on_current_track_finished)
	current_track.stop()
	_finish_sequence()


func _finish_sequence():
	current_track = null
	sequence_finished.emit()
	if is_filming and not queue_empty():
		_play_next_track()


func _map_tracks(actions: Array[teVisualActionBase], speed_scale: float) -> Array[teVisualTrackBase]:
	var tracks: Array[teVisualTrackBase] = []
	tracks.resize(actions.size())
	var idx := 0
	for sub_action in actions:
		tracks[idx] = track(sub_action, speed_scale)
		idx += 1
	return tracks
