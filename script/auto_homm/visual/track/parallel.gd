class_name teVisualParallelTrack extends teVisualTrackBase


var scheduler: teVisualScheduler
var tracks: Array[int]
var playing: int


func _play():
	scheduler.track_finished.connect(_on_track_finished)
	playing = tracks.size()
	for track_id in tracks:
		if scheduler.is_scheduled(track_id):
			scheduler.start(track_id)
		else:
			playing -= 1


func _cancel():
	scheduler.track_finished.disconnect(_on_track_finished)
	for track_id in tracks:
		if scheduler.is_running(track_id):
			scheduler.stop(track_id)


func _on_track_finished(_track: teVisualTrackBase, id: int):
	if not tracks.has(id):
		return
	playing -= 1
	if playing == 0:
		_finish()
