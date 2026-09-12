class_name teGameNode extends Node


@export var visual_config: teVisualGameConfig
@export var setup: teGameSetup
@export var state: teGameState
@export var board: teBoardVisual
@export var ui: teUI
@export var combat: teCombatBase
@export var cinematic: Cinematic
@export var combat_setup: teCombatSetupController
@export var pixel_art3d: teVisualPixelArt3d


var potential_combat_state: teCombatState


func _ready() -> void:
	state = visual_config.read_game_state()
	_activate_combat_setup()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_start_combat"):
		if cinematic.is_live():
			return
		_deactivate_combat_setup()
		_start_combat()
	if event.is_action_pressed("dbg_finish_combat"):
		if not cinematic.is_live():
			return
		_stop_combat()
		_activate_combat_setup()


func _activate_combat_setup() -> void:
	_update_potential_combat_state()
	board.units_go_idle()
	ui.set_setup_mode()
	combat_setup.place_unit_requested.connect(_on_place_unit_requested)
	combat_setup.activate(state.current_team)


func _deactivate_combat_setup() -> void:
	board.clear_all_hover()
	combat_setup.deactivate()
	combat_setup.place_unit_requested.disconnect(_on_place_unit_requested)


func _start_combat() -> void:
	ui.set_combat_mode(potential_combat_state)
	cinematic.finished.connect(_on_cinematic_finished)
	cinematic.start()
	combat.start(potential_combat_state, setup.rule_set.rules)


func _stop_combat() -> void:
	board.clear_all_hover()
	combat.stop()
	cinematic.stop()
	cinematic.finished.disconnect(_on_cinematic_finished)


func _on_place_unit_requested(unit_id: int, hex: Vector2i):
	if not state.current_team.units_placement.has(unit_id):
		return
	var updated_state := state.duplicate(true)
	updated_state.current_team.units_placement.erase(unit_id)
	updated_state.current_team.units_placement.set(unit_id, hex)
	state = updated_state
	combat_setup.update_current_team(state.current_team)
	_update_potential_combat_state()


func _on_cinematic_finished():
	cinematic.finished.disconnect(_on_cinematic_finished)
	board.clear_all_hover()
	_activate_combat_setup()


func _update_potential_combat_state():
	var next_combat := teCombatSetup.new()
	var next_map := teCombatMap.new()
	next_map.grid = setup.grid
	next_combat.map = next_map
	next_combat.teams.push_back(state.current_team)
	next_combat.teams.push_back(state.enemy)
	potential_combat_state = teCombatState.from(
		next_combat, setup.rule_set.units, state.unit_roster
	)
	board.sync_state(potential_combat_state)
	pixel_art3d.sync(potential_combat_state)
	ui.set_potential_combat_state(potential_combat_state)
