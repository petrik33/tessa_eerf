class_name teVisualSequence extends RefCounted


var director: teVisualDirectorBase
var root_action: teVisualActionBase
var timeout_sec: float


func _init(
	pDirector: teVisualDirectorBase,
	pRoot_action: teVisualActionBase,
	pTimeout_sec: float
):
	director = pDirector
	root_action = pRoot_action
	timeout_sec = pTimeout_sec
