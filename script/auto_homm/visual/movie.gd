class_name teCombatMovie extends Node


signal turn_played()
signal finished()


@export var board: teBoardVisual
@export var director: teVisualDirector
@export var writer: teVisualWriter


var combat: teCombat


func _ready() -> void:
	director.sequence_finished.connect(_on_director_sequence_finished)


func _exit_tree() -> void:
	director.sequence_finished.disconnect(_on_director_sequence_finished)


func playing() -> bool:
	return director.playing()


func is_live() -> bool:
	return combat != null


func start(_combat: teCombat):
	if is_live():
		stop()
	combat = _combat
	combat.started.connect(_on_combat_started)
	combat.action_taken.connect(_on_combat_action_taken)


func stop():
	director.clear_queue()
	if not is_live():
		return
	combat.action_taken.disconnect(_on_combat_action_taken)
	combat.started.disconnect(_on_combat_started)
	combat = null


func _on_combat_action_taken(state: teCombatState, resolved: teCombatResolvedAction):
	var sequence := writer.sequence(state, resolved.action, resolved.events)
	if sequence == null:
		return
	director.play(sequence, 0.5)


func _on_combat_started(initial_state: teCombatState):
	board.sync_state(initial_state)


func _on_director_sequence_finished():
	turn_played.emit()
	if director.queue_empty():
		finished.emit()
