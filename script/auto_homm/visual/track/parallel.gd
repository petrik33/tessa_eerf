class_name teVisualParallelTrack extends teVisualTrackBase


var tracks: Array[teVisualTrackBase]
var playing: int


func _play():
	for track in tracks:
		if track == null:
			continue
		track.start()
		if track.is_finished:
			continue
		track.finished.connect(_on_sub_track_finished, CONNECT_ONE_SHOT)
		playing += 1
	if playing == 0:
		_finish()


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
