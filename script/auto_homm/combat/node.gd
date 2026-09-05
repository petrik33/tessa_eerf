class_name teCombat extends teCombatBase


@export var turn_timer: Timer


func _next_step():
	_try_process_command(_next_command())
	if rules.is_finished(state):
		_finish()
		return
	turn_timer.start()


func _next_command() -> teCombatCommandBase:
	if rules.is_hero_turn(state):
		return teCombatCommands.skip_hero_turn()
	else:
		return rules.auto_command(runtime, state)


func _on_timer_timeout():
	if is_active():
		_next_step()
