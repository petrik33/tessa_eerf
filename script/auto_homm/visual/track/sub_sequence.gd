class_name teVisualSubSequenceTrack extends teVisualTrackBase


var tracks: Array[teVisualTrackBase]
var current_track_idx: int


func _play():
	current_track_idx = -1
	_play_next_track()


func _cancel():
	tracks[current_track_idx].finished.disconnect(_play_next_track)
	tracks[current_track_idx].stop()


func _play_next_track():
	current_track_idx += 1
	if current_track_idx > tracks.size() - 1:
		_finish()
		return
	var track := tracks[current_track_idx]
	if track == null:
		_play_next_track()
		return
	track.finished.connect(_play_next_track, CONNECT_ONE_SHOT)
	track.start()
