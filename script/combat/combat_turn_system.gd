class_name CombatTurnSystem extends Node

signal turn_started(turn_handle: CombatHandle)
signal turn_finished(turn_handle: CombatHandle)
signal wait_started(reason: StringName)
signal wait_reason_changed(new_reason: StringName)
signal wait_finished()

# TODO: Assert `start -> progress -> finish` flow

func start_combat(turn_handle: CombatHandle):
	_turn_handle = turn_handle
	turn_started.emit(turn_handle)


func progress_combat(next_turn_handle: CombatHandle):
	turn_finished.emit(_turn_handle)
	_turn_handle = next_turn_handle
	for wait in _auto_waits:
		add_wait(wait)
	if _waits.is_empty():
		turn_started.emit(_turn_handle)
		return
	wait_started.emit()


func finish_combat():
	turn_finished.emit(_turn_handle)
	_turn_handle = null


# TODO: Implement timeout on waits
func add_wait(reason: StringName):
	_waits.append(reason)


func remove_wait(reason: StringName):
	var reason_idx = _waits.find(reason)
	if reason_idx == -1:
		return
	_waits.remove_at(reason_idx)
	if reason_idx != 0:
		return
	if _waits.is_empty():
		wait_finished.emit()
		turn_started.emit(_turn_handle)
	else:
		wait_reason_changed.emit(_waits.front())


func add_auto_wait(reason: StringName):
	_auto_waits.append(reason)


func remove_auto_wait(reason: StringName):
	_auto_waits.append(reason)


var _turn_handle: CombatHandle
var _waits: Array[StringName] = []
var _auto_waits: Array[StringName] = []
