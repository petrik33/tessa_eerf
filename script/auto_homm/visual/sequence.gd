class_name teVisualSequence extends RefCounted


var root_action: teVisualActionBase
var timeout_sec: float


func _init(_root_action: teVisualActionBase, _timeout_sec: float):
	root_action = _root_action
	timeout_sec = _timeout_sec
