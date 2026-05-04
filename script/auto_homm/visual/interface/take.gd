class_name teVisualTake extends RefCounted


signal cut()
signal aborted()


var is_cut: bool
var is_aborted: bool


func abort():
	if is_cut:
		return
	is_aborted = true
	_on_abort()
	aborted.emit()
	_cut()


func _on_abort():
	pass


func _cut():
	is_cut = true
	cut.emit()
