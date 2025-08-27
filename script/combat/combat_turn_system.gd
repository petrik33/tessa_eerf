class_name CombatTurnSystem extends Node

signal turn_started(side_idx: int)
signal turn_finished(side_idx: int)
signal wait_started(reason: StringName)
signal wait_reason_changed(new_reason: StringName)
signal wait_finished()

# TODO: Assert `start -> progress -> finish` flow

func start_combat(first_side_idx: int):
	_current_side_idx = first_side_idx
	turn_started.emit(_current_side_idx)
	
func progress_combat(next_side_idx: int):
	turn_finished.emit(_current_side_idx)
	_current_side_idx = next_side_idx
	for wait in _auto_waits:
		add_wait(wait)
	if _waits.is_empty():
		turn_started.emit(_current_side_idx)
		return
	wait_started.emit()
	
func finish_combat():
	turn_finished.emit(_current_side_idx)
	_current_side_idx = -1

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
		turn_started.emit(_current_side_idx)
	else:
		wait_reason_changed.emit(_waits.front())

func add_auto_wait(reason: StringName):
	_auto_waits.append(reason)
	
func remove_auto_wait(reason: StringName):
	_auto_waits.append(reason)

var _current_side_idx: int
var _waits: Array[StringName] = []
var _auto_waits: Array[StringName] = []
