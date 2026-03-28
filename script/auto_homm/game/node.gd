class_name teGameNode extends Node


@export var visual_config: teVisualGameConfig
@export var setup: teGameSetup
@export var state: teGameState
@export var board: teBoardVisual
@export var combat: teCombat
@export var movie: teCombatMovie
@export var combat_setup: teCombatSetupController

# Shouldn't be here
@export var units_node: Node2D
@export var unit_view_scene: PackedScene


var combat_services: teCombatServices


func _ready() -> void:
	state = visual_config.read_game_state()
	var id := 0
	for visuals in visual_config.get_unit_visuals():
		var unit_view := _create_unit_view(visuals)
		board.attach_unit(unit_view, id)
		id += 1
	board.sync_unit_positions(state.enemy) # Shouldn't be here I suppose
	combat_setup.activate(state.current_team)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		if combat.is_active():
			return
		if movie.playing():
			return
		combat_setup.deactivate()
		var next_combat := teCombatSetup.new()
		var next_map := teCombatMap.new()
		next_map.grid = setup.grid
		next_combat.map = next_map
		next_combat.teams.push_back(state.enemy)
		next_combat.teams.push_back(state.current_team)
		combat_services = teCombatServices.new(next_combat)
		var initial_combat_state = teCombatState.from(
			next_combat, setup.rule_set.units, state.unit_roster
		)
		movie.live(combat)
		combat.start(initial_combat_state, setup.rule_set, combat_services)
	if event.is_action_pressed("dbg_finish_combat"):
		if combat.is_active():
			combat.stop()
			combat_services = null
		if movie.playing():
			await movie.turn_played
		if movie.is_live():
			movie.stop_live()
		board.sync_unit_positions(state.enemy)
		if not combat_setup.is_active():
			combat_setup.activate(state.current_team)


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
	#if not setup.rule_set.rules.is_valid(updated_state):
		#return
	state = updated_state
	combat_setup.update_current_team(state.current_team)


func _on_combat_finished(_final_state: teCombatState):
	board.sync_unit_positions(state.enemy)
	combat_setup.activate(state.current_team)
