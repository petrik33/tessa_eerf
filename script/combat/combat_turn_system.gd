class_name CombatTurnSystem extends Node


signal wait_started(reason: StringName)
signal wait_reason_changed(new_reason: StringName)
signal wait_finished()

# TODO: Assert `start -> progress -> finish` flow

func start(turn_handle: CombatHandle):
	_turn_handle = turn_handle


func progress(next_turn_handle: CombatHandle) -> bool:
	_turn_handle = next_turn_handle
	for queued_wait in _queued_waits:
		_active_waits.append(queued_wait)
	_queued_waits.clear()
	if not is_waiting():
		return true
	wait_started.emit(_active_waits.front())
	return false


func finish():
	_turn_handle = null


# TODO: Implement timeout on waits
func add_wait(reason: StringName):
	if is_waiting():
		_active_waits.append(reason)
	else:
		_queued_waits.append(reason)


func remove_wait(reason: StringName):
	var queued_idx = _queued_waits.find(reason)
	if queued_idx != -1:
		_queued_waits.remove_at(queued_idx)
		return
	var active_idx = _active_waits.find(reason)
	if active_idx == -1:
		return
	_active_waits.remove_at(active_idx)
	if _active_waits.is_empty():
		wait_finished.emit()
	else:
		wait_reason_changed.emit(_active_waits.pop_front())


func is_waiting() -> bool:
	return not _active_waits.is_empty()


var _turn_handle: CombatHandle
var _active_waits: Array[StringName] = []
var _queued_waits: Array[StringName] = []
