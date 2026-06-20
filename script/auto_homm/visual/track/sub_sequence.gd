class_name teVisualSubSequenceTrack extends teVisualTrackBase


var scheduler: teVisualScheduler
var tracks: Array[int]
var current_track_idx: int
var current_track_id: int


func _play():
	scheduler.track_finished.connect(_on_track_finished)
	current_track_idx = -1
	_play_next_track()


func _cancel():
	scheduler.track_finished.disconnect(_on_track_finished)
	scheduler.stop(current_track_id)


func _play_next_track():
	current_track_idx += 1
	if current_track_idx > tracks.size() - 1:
		_finish()
		return
	current_track_id = tracks[current_track_idx]
	if not scheduler.is_scheduled(current_track_id):
		_play_next_track()
		return
	scheduler.start(current_track_id)


func _on_track_finished(_track: teVisualTrackBase, id: int):
	if id != current_track_id:
		return
	_play_next_track()
