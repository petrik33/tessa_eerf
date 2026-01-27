@tool
class_name acBattleState extends Resource


@export var board: acBoardState
@export var units: Dictionary[int, acUnitState] = {}
@export var teams: Dictionary[int, acTeamState] = {}


func issue_move(unit: acUnitState, target_hex: Vector2i):
	if not is_valid_move(unit, target_hex):
		return
	board.units.erase(unit.hex)
	board.units[target_hex] = unit
	unit.hex = target_hex


func is_valid_move(_unit: acUnitState, target_hex: Vector2i) -> bool:
	return not is_occupied(target_hex)


func get_unit_at_hex(hex: Vector2i) -> acUnitState:
	return board.units.get(hex)


func is_occupied(hex: Vector2i) -> bool:
	return board.units.has(hex)
