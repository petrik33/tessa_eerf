class_name teVisualDirectorTrackBase extends RefCounted


signal finished()


var is_done: bool = false


func _finish():
	if is_done:
		return
	is_done = true
	finished.emit()


func play(): pass
func cancel(): pass
