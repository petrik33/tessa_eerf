class_name teVisualScheduler extends Node


signal track_started(track: teVisualTrackBase, id: int)
signal track_finished(track: teVisualTrackBase, id: int)


var scheduled: Dictionary[int, teVisualTrackBase] = {}
var active: Dictionary[int, teVisualTrackBase] = {}
var finished: Dictionary[int, teVisualTrackBase] = {}


func clear():
	_track_counter = -1
	scheduled.clear()
	active.clear()
	finished.clear()


func get_track(id: int) -> teVisualTrackBase:
	return scheduled.get(id, null)


func schedule(
	director: teVisualDirectorBase,
	action: teVisualActionBase,
	speed_scale: float
) -> int:
	var track := _map_track(director, action, speed_scale)
	if track == null:
		return -1
	_track_counter += 1
	track.started.connect(_on_track_started.bind(_track_counter), CONNECT_ONE_SHOT)
	track.finished.connect(_on_track_finished.bind(_track_counter), CONNECT_ONE_SHOT)
	scheduled.set(_track_counter, track)
	return _track_counter


func is_scheduled(track_id: int) -> bool:
	return scheduled.has(track_id)


func is_running(track_id: int) -> bool:
	return active.has(track_id)


func is_finished(track_id: int) -> bool:
	return finished.has(track_id)


func start(track_id: int):
	if not is_scheduled(track_id):
		return
	scheduled[track_id].start()


func stop(track_id: int):
	if not is_running(track_id):
		return
	active[track_id].stop()


var _track_counter := -1


func _map_track(
	director: teVisualDirectorBase,
	action: teVisualActionBase,
	speed_scale: float
) -> teVisualTrackBase:
	if action == null:
		return null
	if action is teVisualActionParallel:
		return teVisualTracks.parallel(self, _map_tracks(director, action.actions, speed_scale))
	if action is teVisualActionSubSequence:
		return teVisualTracks.sub_sequence(self, _map_tracks(director, action.actions, speed_scale))
	return teVisualTracks.take(director, action, speed_scale)


func estimate_duration(director: teVisualDirectorBase, action: teVisualActionBase) -> float:
	if action == null:
		return 0.0
	if action is teVisualActionParallel:
		var max_duration := 0.0
		for sub_action in action.actions:
			max_duration = max(max_duration, estimate_duration(director, sub_action))
		return max_duration
	if action is teVisualActionSubSequence:
		var total_duration := 0.0
		for sub_action in action.actions:
			total_duration += estimate_duration(director, sub_action)
		return total_duration
	return director.estimate_duration(action)


func _map_tracks(
	director: teVisualDirectorBase,
	actions: Array[teVisualActionBase],
	speed_scale: float
) -> Array[int]:
	var tracks: Array[int] = []
	tracks.resize(actions.size())
	var idx := 0
	for sub_action in actions:
		tracks[idx] = schedule(director, sub_action, speed_scale)
		idx += 1
	return tracks


func _on_track_started(track_id: int):
	var track := scheduled[track_id]
	scheduled.erase(track_id)
	active.set(track_id, track)
	track_started.emit(track, track_id)


func _on_track_finished(track_id: int):
	var track := active[track_id]
	finished.set(track_id, track)
	active.erase(track_id)
	track_finished.emit(track, track_id)
