class_name teGameNode extends Node


@export var visual_config: teVisualGameConfig
@export var setup: teGameSetup
@export var state: teGameState
@export var simulation_runner: teCombatSimulationRunner
@export var board: teBoardView
@export var movie: teCombatMovie


var combat_simulation_id := -1


func _ready() -> void:
	state = visual_config.read_game_state()
	var id := 0
	for unit_visuals in visual_config.get_unit_visuals():
		board.attach_unit(unit_visuals, id)
		id += 1
	_fix_unit_positions(state.current_team)
	_fix_unit_positions(state.enemy)



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
	if event.is_action_pressed("dbg_finish_combat"):
		simulation_runner.turn_progressed.disconnect(_on_turn_progressed)
		simulation_runner.stop(combat_simulation_id)


func _on_turn_progressed(simulation_id: int, turn_log: teCombatEventLog):
	if simulation_id != combat_simulation_id:
		return
	movie.run(turn_log)


func _fix_unit_positions(team: teCombatTeam):
	for unit_id in team.units_placement.keys():
		var unit_view := board.get_unit(unit_id)
		unit_view.position = board.hex_space.layout.hex_to_pixel(
			team.units_placement[unit_id]
		)
	
	
