class_name teVisualDirectorSignaledTrack extends teVisualDirectorTrackBase


var _signal: Signal


func play():
	await _signal
	_finish()
