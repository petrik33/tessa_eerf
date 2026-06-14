class_name teVisualTrackBackground extends teVisualTrackBase


var sub_track: teVisualTrackBase


func _play():
	sub_track.start()
	sub_track.finished.connect(_on_sub_track_finished, CONNECT_ONE_SHOT)
	_finish()
	is_playing = true


func _cancel():
	sub_track.stop() 


func _on_sub_track_finished():
	is_playing = false
