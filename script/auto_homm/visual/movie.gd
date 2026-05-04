class_name teCombatMovie extends Node


signal turn_played()
signal finished()


@export var board: teBoardVisual
@export var producer: teVisualProducer
@export var writer: teVisualWriterBase
@export var cutter: teVisualCutterBase


var combat: teCombat


func is_playing() -> bool:
	return producer.is_playing()


func is_live() -> bool:
	return combat != null


func start(_combat: teCombat):
	if is_live():
		stop()
	combat = _combat
	combat.started.connect(_on_combat_started)
	combat.action_taken.connect(_on_combat_action_taken)
	producer.start()


func stop():
	if not is_live():
		return
	producer.stop()
	combat.action_taken.disconnect(_on_combat_action_taken)
	combat.started.disconnect(_on_combat_started)
	combat = null


func _on_combat_action_taken(state: teCombatState, resolved: teCombatResolvedAction):
	var root_action := writer.sequence(state, resolved.action, resolved.events)
	if root_action == null:
		return
	producer.enqueue(root_action, cutter.cut_time(resolved.action))


func _on_combat_started(initial_state: teCombatState):
	board.sync_state(initial_state)


func _on_producer_sequence_finished():
	turn_played.emit()
	if is_live() and not combat.is_active() and producer.queue_empty():
		finished.emit()
	
