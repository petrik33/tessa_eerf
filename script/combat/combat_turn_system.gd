class_name CombatTurnSystem extends Node


signal wait_started(reason: StringName)
signal wait_reason_changed(new_reason: StringName)
signal wait_finished()

# TODO: Assert `start -> progress -> finish` flow

func start(turn_handle: CombatHandle):
	_turn_handle = turn_handle
	for wait in _auto_waits:
		add_wait(wait)


func progress(next_turn_handle: CombatHandle) -> bool:
	_turn_handle = next_turn_handle
	if _waits.is_empty():
		return true
	_current_wait = _waits.pop_front()
	wait_started.emit(_current_wait)
	return false


func finish():
	_turn_handle = null


# TODO: Implement timeout on waits
func add_wait(reason: StringName):
	_waits.append(reason)


func remove_wait(reason: StringName):
	var reason_idx = _waits.find(reason)
	if reason_idx == -1:
		return
	_waits.remove_at(reason_idx)
	if reason_idx != 0 or not is_waiting():
		return
	if _waits.is_empty():
		_current_wait = ""
		wait_finished.emit()
		for wait in _auto_waits:
			add_wait(wait)
	else:
		wait_reason_changed.emit(_waits.front())


func is_waiting() -> bool:
	return not _current_wait.is_empty()


func add_auto_wait(reason: StringName):
	_auto_waits.append(reason)


func remove_auto_wait(reason: StringName):
	_auto_waits.erase(reason)


var _turn_handle: CombatHandle
var _waits: Array[StringName] = []
var _current_wait: StringName = ""
var _auto_waits: Array[StringName] = []
