class_name teCombatMovie extends Node


signal sequence_played()
signal finished()


@export var playback: teMoviePlayback
@export var producer: teMovieProducer

@export var combat: teCombat


func start():
	if _is_live:
		stop()
	_is_live = true
	combat.started.connect(_on_combat_started)
	combat.action_taken.connect(_on_combat_action_taken)
	combat.finished.connect(_on_combat_finished)
	playback.sequence_finished.connect(_on_playback_sequence_finished)
	playback.start()


func stop():
	if not _is_live:
		return
	playback.stop()
	playback.clear_queue()
	playback.sequence_finished.disconnect(_on_playback_sequence_finished)
	combat.finished.disconnect(_on_combat_finished)
	combat.action_taken.disconnect(_on_combat_action_taken)
	combat.started.disconnect(_on_combat_started)
	_is_live = false


func pause():
	assert(_is_live)
	playback.stop()


func resume():
	assert(_is_live)
	playback.start()


func is_live() -> bool:
	return _is_live


var _is_live: bool


func _on_combat_started(_initial_state: teCombatState):
	pass


func _on_combat_action_taken(state: teCombatState, resolved: teCombatResolvedAction):
	playback.enqueue(producer.sequence(state, resolved))


func _on_combat_finished(_final_state: teCombatState):
	pass


func _on_playback_sequence_finished():
	sequence_played.emit()
	if playback.queue_empty() and not combat.is_active():
		finished.emit()
		stop()
