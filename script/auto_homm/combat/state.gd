class_name teCombatState extends Resource


@export var units: Dictionary[int, teCombatUnitState]
@export var unit_teams: Dictionary[int, int]
@export var turn_queue: Array[int]


func update(log: teCombatEventLog):
	for event in log.events:
		apply_event(event)


func apply_event(event: teCombatEventBase):
	if event is teCombatEventTurnProgressed:
		turn_queue.push_back(turn_queue.pop_front())


func current_unit_id() -> int:
	return turn_queue.front()


func unit(unit_id: int) -> teCombatUnitState:
	return units[unit_id]


func allies_id(unit_id: int) -> Array[int]:
	var allies: Array[int] = []
	var unit_team := unit_teams[unit_id]
	for other_id in units:
		if unit_teams[other_id] == unit_team:
			allies.push_back(other_id)
	return allies


func enemies_id(unit_id: int) -> Array[int]:
	var enemies: Array[int] = []
	var unit_team := unit_teams[unit_id]
	for other_id in units:
		if unit_teams[other_id] != unit_team:
			enemies.push_back(other_id)
	return enemies
