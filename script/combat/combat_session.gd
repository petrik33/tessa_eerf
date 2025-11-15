class_name CombatSession extends Node


@export var combat: Combat
@export var controller: CombatController
@export var visual: CombatVisual
@export var ui: CombatUI

# TODO: Configuration system
@export var wait_visual := true


var services: CombatServices
var turn_context: CombatTurnContext


const VISUAL_WAIT_REASON := "visual_playing"


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
	if wait_visual:
		combat.add_auto_wait(VISUAL_WAIT_REASON)
	ui.potential_command_changed.connect(_on_potential_command_changed)
	ui.command_requested.connect(_on_command_requested)
	controller.setup()
	var initial_observed_state = combat.observe_state()
	visual.setup(initial_observed_state)
	ui.setup(initial_observed_state, visual)


func _on_combat_finished():
	ui.reset()
	visual.reset()
	controller.reset()
	ui.command_requested.disconnect(_on_command_requested)
	ui.potential_command_changed.disconnect(_on_potential_command_changed)
	if wait_visual:
		combat.remove_auto_wait(VISUAL_WAIT_REASON)


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
	ui.start_turn(turn_context)


func _on_combat_turn_finished(turn_handle: CombatHandle):
	if not controller.is_turn_controlled(turn_handle):
		return
	ui.finish_turn()


func _on_combat_command_processed(command: CombatCommandBase, actions: CombatActionsBuffer):
	await visual.visualize(turn_context.observed_state, command, actions)
	# TODO: Pass proper handle to observe state
	ui.update_observed_state(combat.observe_state())
	combat.remove_wait(VISUAL_WAIT_REASON)


func _on_potential_command_changed(command: CombatCommandBase):
	pass


func _on_command_requested(command: CombatCommandBase):
	combat.request_command(command)
	
	
func _on_visual_queue_empty():
	pass	
