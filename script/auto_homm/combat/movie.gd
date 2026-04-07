class_name teCombatMovie extends Node


signal turn_played()
signal finished()


@export var board: teBoardVisual
@export var director: teVisualDirector
@export var writer: teVisualWriter


var live_combat: teCombat


func _ready() -> void:
	director.sequence_finished.connect(_on_director_sequence_finished)


func _exit_tree() -> void:
	director.sequence_finished.disconnect(_on_director_sequence_finished)


func playing() -> bool:
	return director.playing()


func replay(initial_state: teCombatState, turn_history: teCombatTurnHistory):
	if is_live():
		stop_live()
	board.sync_state(initial_state)
	var turn_state := initial_state.duplicate()
	for turn in turn_history.turns:
		play_turn(turn_state, turn)
		turn_state.update(turn)


func is_live() -> bool:
	return live_combat != null


func live(combat: teCombat):
	if is_live():
		stop_live()
	live_combat = combat
	combat.started.connect(_on_live_combat_started)
	combat.turn_finished.connect(_on_live_combat_turn_finished)


func stop_live():
	director.clear_queue()
	live_combat.turn_finished.disconnect(_on_live_combat_turn_finished)
	live_combat.started.disconnect(_on_live_combat_started)
	live_combat = null


func play_turn(state: teCombatState, turn_log: teCombatTurnLog):
	director.play(writer.sequence(state, turn_log))


func _on_live_combat_updated(updated_state: teCombatState, event: teCombatEventBase):
	var sequence := teVisualSequence.new()
	sequence.actions = [writer.write(updated_state, event)]
	director.play(sequence)


func _on_live_combat_turn_finished(initial_state: teCombatState, turn_log: teCombatTurnLog):
	play_turn(initial_state, turn_log)


func _on_live_combat_started(initial_state: teCombatState):
	board.sync_state(initial_state)


func _on_director_sequence_finished():
	turn_played.emit()
	if director.queue_empty():
		finished.emit()
