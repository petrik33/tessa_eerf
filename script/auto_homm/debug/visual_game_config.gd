class_name teVisualGameConfig extends Node


@export var units_node: Node2D
@export var hex_space: HexSpace
@export var skin_set: teUnitSkinSet

@export var ally_grid: HexGridBase
@export var enemy_grid: HexGridBase


func read_game_state() -> teGameState:
	var state := teGameState.new()
	var unit_id = 0
	var unit_visuals: Array[Node2D] = []
	
	for node in units_node.get_children():
		if node is teUnitVisualsBase and node.visible:
			unit_visuals.append(node)
	
	for visuals in unit_visuals:
		var unit := teCombatUnit.new()
		unit.definition_uid = try_find_unit_definition_uid_by_visuals(visuals)
		unit.rank = 1
		var hex := hex_space.layout.pixel_to_hex(visuals.position)
		var team := state.current_team if ally_grid.has_point(hex) else state.enemy
		state.unit_roster.all_units.push_back(unit)
		team.units_placement[unit_id] = hex 
		if team == state.current_team:
			state.squad.units_id.append(unit_id)
		unit_id += 1
	
	for visuals in unit_visuals:
		visuals.queue_free()
	unit_visuals.clear()
	
	return state


func try_find_unit_definition_uid_by_visuals(visuals: Node2D) -> StringName:
	var scene_path := visuals.scene_file_path
	for key in skin_set.scenes.keys():
		if skin_set.scenes[key].resource_path == scene_path:
			return key
	return ""
