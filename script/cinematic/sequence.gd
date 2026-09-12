class_name CinematicSequence extends RefCounted


var director: CinematicDirectorBase
var root_action: teVisualActionBase
var timeout_sec: float


func _init(
	pDirector: CinematicDirectorBase,
	pRoot_action: teVisualActionBase,
	pTimeout_sec: float
):
	director = pDirector
	root_action = pRoot_action
	timeout_sec = pTimeout_sec
