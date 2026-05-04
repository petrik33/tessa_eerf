class_name teVisualSubSequenceTrack extends teVisualTrackBase


var tracks: Array[teVisualTrackBase]
var current_track_idx: int


func _play():
	current_track_idx = -1
	_play_next_track()


func _cancel():
	tracks[current_track_idx].finished.disconnect(_on_sub_track_finished)
	tracks[current_track_idx].stop()


func _on_sub_track_finished():
	if current_track_idx == tracks.size() - 1:
		_finish()
	else:
		_play_next_track()
	

func _play_next_track():
	current_track_idx += 1
	var track := tracks[current_track_idx]
	track.finished.connect(_on_sub_track_finished, CONNECT_ONE_SHOT)
	track.start()
