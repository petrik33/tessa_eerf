class_name teHeroCombat extends teCombatBase


@export var cinematic_playback: CinematicPlayback
@export var hero_state: teHeroCombatState
@export var controller: teHeroCombatController


func _ready() -> void:
	controller.command_requested.connect(_on_controller_command_requested)


func _next_step():
	var current_unit_id := state.active_unit_id()
	var auto_command := rules.auto_command(runtime, state)
	if hero_state.is_hero(current_unit_id):
		while not cinematic_playback.queue_empty():
			await cinematic_playback.sequence_finished
		controller.activate(state, runtime, auto_command)
	else:
		var processed := _try_process_command(auto_command)
		#assert(processed, "Couldn't process auto command")
		_next_step()


func _on_controller_command_requested(command: teCombatCommandBase):
	if _try_process_command(command):
		controller.deactivate()
		_next_step()
