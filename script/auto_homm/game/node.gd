class_name teGameNode extends Node


@export var visual_config: teVisualGameConfig
@export var rules: teGameRules
@export var setup: teGameSetup
@export var state: teGameState
@export var simulation_runner: teCombatSimulationRunner
@export var board: teBoardVisual
@export var movie: teCombatMovie
@export var combat_setup: teCombatSetupController

# Shouldn't be here
@export var units_node: Node2D
@export var unit_view_scene: PackedScene 


var combat_simulation_id := -1
var selected_unit_id := -1


func _ready() -> void:
	state = visual_config.read_game_state()
	var id := 0
	for visuals in visual_config.get_unit_visuals():
		var unit_view := _create_unit_view(visuals)
		board.attach_unit(unit_view, id)
		id += 1
	board.sync_unit_positions(state.enemy) # Shouldn't be here
	combat_setup.activate(state.current_team)
	combat_setup.place_unit_requested.connect(_on_place_unit_requested)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		var next_combat := teCombatSetup.new()
		var next_map := teCombatMap.new()
		next_map.grid = setup.grid
		next_combat.map = next_map
		next_combat.teams[0] = state.current_team
		next_combat.teams[1] = state.enemy
		combat_simulation_id = simulation_runner.start(
			setup.rule_set.rules,
			next_combat
		)
		simulation_runner.turn_progressed.connect(_on_turn_progressed)
		combat_setup.place_unit_requested.disconnect(_on_place_unit_requested)
		combat_setup.deactivate()
	if event.is_action_pressed("dbg_finish_combat"):
		simulation_runner.turn_progressed.disconnect(_on_turn_progressed)
		simulation_runner.stop(combat_simulation_id)
		combat_setup.activate(state.current_team)
		combat_setup.place_unit_requested.connect(_on_place_unit_requested)


func _on_turn_progressed(simulation_id: int, turn_log: teCombatEventLog):
	if simulation_id != combat_simulation_id:
		return
	movie.run(turn_log)


func _create_unit_view(visuals: Node2D) -> teUnitView:
	var unit_view := unit_view_scene.instantiate() as teUnitView
	units_node.add_child(unit_view)
	visuals.position = Vector2.ZERO
	visuals.reparent(unit_view, false)
	unit_view.attach_visuals(visuals)
	return unit_view


func _on_place_unit_requested(unit_id: int, hex: Vector2i):
	if not state.current_team.units_placement.has(unit_id):
		return
	var updated_state := state.duplicate(true)
	updated_state.current_team.units_placement.erase(unit_id)
	updated_state.current_team.units_placement.set(unit_id, hex)
	if not rules.is_valid_state(updated_state):
		return
	state = updated_state
	combat_setup.update_current_team(state.current_team)
