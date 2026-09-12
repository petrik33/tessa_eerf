class_name CinematicTakeSignaled extends CinematicTake


var _signal: Signal


func _init(cut_signal: Signal):
	_signal = cut_signal
	_signal.connect(_on_signal)


func _on_signal():
	_cut()


func _on_abort():
	_signal.disconnect(_on_signal)
