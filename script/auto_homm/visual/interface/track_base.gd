@abstract
class_name teVisualTrackBase extends RefCounted


signal finished()


var is_playing: bool
var is_finished: bool
var is_stopped: bool


func start():
	if is_playing:
		stop()
	is_playing = true
	is_finished = false
	is_stopped = false
	_play()


func stop():
	if not is_playing or is_finished:
		return
	is_playing = false
	is_stopped = true
	_cancel()
	_finish()


@abstract func _play()
@abstract func _cancel()


func _finish():
	is_finished = true
	finished.emit()
