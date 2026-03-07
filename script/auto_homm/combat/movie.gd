class_name teCombatMovie extends Node


signal turn_played()


@export var board: teBoardVisual
@export var director: teVisualDirector
@export var writer: teVisualWriter


var live_combat: teCombat


func playing() -> bool:
	return director.playing()


func replay(initial_state: teCombatState, turn_history: teCombatTurnHistory):
	if is_live():
		stop_live()
	board.sync_state(initial_state)
	for turn in turn_history.turns:
		play_turn(turn)


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


func play_turn(turn_log: teCombatEventLog):
	director.play(writer.sequence(turn_log))
	await director.sequence_finished
	turn_played.emit()


func _on_live_combat_turn_finished(turn_log: teCombatEventLog):
	play_turn(turn_log)


func _on_live_combat_started(initial_state: teCombatState):
	board.sync_state(initial_state)
