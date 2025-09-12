class_name CombatSession extends Node


@export var visual: CombatVisual
@export var controller: CombatController
@export var ui: CombatUI
@export var combat: Combat


var services: CombatServices
var turn_context: CombatTurnContext


func _enter_tree() -> void:
	combat.started.connect(_on_combat_started)
	combat.finished.connect(_on_combat_finished)
	combat.turn_started.connect(_on_combat_turn_started)
	combat.turn_finished.connect(_on_combat_turn_finished)
	combat.command_processed.connect(_on_combat_command_processed)
	
	
func _exit_tree() -> void:
	combat.command_processed.disconnect(_on_combat_command_processed)
	combat.turn_finished.disconnect(_on_combat_turn_finished)
	combat.turn_started.disconnect(_on_combat_turn_started)
	combat.finished.disconnect(_on_combat_finished)
	combat.started.disconnect(_on_combat_started)


func _on_combat_started():
	services = CombatServices.new(combat.definition)
	controller.potential_command_changed.connect(_on_controller_potential_command_changed)
	controller.command_requested.connect(_on_controller_command_requested)
	controller.setup()
	var initial_observed_state = combat.observe_state()
	visual.setup(initial_observed_state)
	ui.setup(initial_observed_state, visual)


func _on_combat_finished():
	ui.reset()
	visual.reset()
	controller.reset()
	controller.command_requested.disconnect(_on_controller_command_requested)
	controller.potential_command_changed.disconnect(_on_controller_potential_command_changed)


func _on_combat_turn_started(turn_handle: CombatHandle):
	var turn_controlled := controller.is_turn_controlled(turn_handle)
	var controlled_army_handle := turn_handle if turn_controlled else null
	var observed_state := combat.observe_state(controlled_army_handle)
	services.update(observed_state)
	turn_context = CombatTurnContext.new(
		observed_state,
		services
	)
	if not turn_controlled:
		return
	controller.enable(turn_context)
	ui.enable_turn_outlines(turn_context)


func _on_combat_turn_finished(turn_handle: CombatHandle):
	if not controller.is_turn_controlled(turn_handle):
		return
	ui.disable_turn_outlines()
	controller.disable()


func _on_combat_command_processed(command: CombatCommandBase, actions: CombatActionsBuffer):
	visual.visualize(turn_context.observed_state, command, actions)
	# TODO: Pass proper handle to observe state
	ui.update_observed_state(combat.observe_state())


func _on_controller_potential_command_changed(command: CombatCommandBase):
	ui.update_potential_command(turn_context, command)


func _on_controller_command_requested(command: CombatCommandBase):
	combat.request_command(command)
