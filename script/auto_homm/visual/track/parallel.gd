class_name teVisualParallelTrack extends teVisualTrackBase


var tracks: Array[teVisualTrackBase]
var playing: int


func _play():
	playing = tracks.size()
	if playing == 0:
		_finish()
	for track in tracks:
		track.finished.connect(_on_sub_track_finished, CONNECT_ONE_SHOT)
		track.start()


func _cancel():
	if playing == 0:
		return
	for track in tracks:
		if track.is_finished:
			continue
		track.finished.disconnect(_on_sub_track_finished)
		track.stop()
	playing = 0


func _on_sub_track_finished():
	playing -= 1
	if playing == 0:
		_finish()
