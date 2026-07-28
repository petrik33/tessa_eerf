class_name teCombatMovie extends Node


signal turn_played()
signal queue_empty()
signal finished()


@export var board: teBoardVisual
@export var producer: teVisualProducer
@export var writer: teVisualWriterBase
@export var cutter: teVisualCutterBase


func is_playing() -> bool:
	return producer.is_playing()


func is_filming() -> bool:
	return _live


func start_filming():
	if is_filming():
		stop_filming()
	producer.start()
	_live = true


func stop_filming():
	producer.stop()
	finish_filming()


func finish_filming():
	_live = false
	

var _live: bool


func _on_combat_action_taken(state: teCombatState, resolved: teCombatResolvedAction):
	var root_action := writer.sequence(state, resolved.action, resolved.context, resolved.emitted_events)
	if root_action == null:
		return
	producer.enqueue(root_action, cutter.cut_time(resolved.action))


func _on_producer_sequence_finished():
	turn_played.emit()
	if not producer.queue_empty():
		return
	queue_empty.emit()
	if not is_filming():
		finished.emit()
