@tool
class_name teGameRules extends Resource


@export var ally_grid: HexGridBase
@export var enemy_grid: HexGridBase
@export var combat_grid: HexGridBase


func is_valid_state(state: teGameState) -> bool:
	return true
