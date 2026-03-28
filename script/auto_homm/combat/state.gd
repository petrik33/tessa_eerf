class_name teCombatState extends Resource


@export var units: Dictionary[int, teCombatUnitState]
@export var unit_teams: Dictionary[int, int]
@export var turn_queue: Array[int]


static func from(setup: teCombatSetup, unit_set: teUnitSet, unit_roster: teCombatUnitRoster) -> teCombatState:
	var state := teCombatState.new()
	var team_id := 0
	for team in setup.teams:
		for unit_id in team.units_placement:
			var placed_unit := unit_roster.get_unit(unit_id)
			var unit_initial_state := teCombatUnitState.new()
			var unit_definition := unit_set.get_definition(placed_unit.definition_uid)
			unit_initial_state.hex = team.units_placement[unit_id]
			unit_initial_state.hp = unit_definition.stats.max_hp
			unit_initial_state.mana = 0
			unit_initial_state.definition_uid = placed_unit.definition_uid
			state.units[unit_id] = unit_initial_state
			state.unit_teams[unit_id] = team_id
		team_id += 1
	for unit_id in state.units:
		state.turn_queue.push_back(unit_id)
	return state


func update(turn_log: teCombatEventLog):
	for event in turn_log.events:
		apply_event(event)


func apply_event(event: teCombatEventBase):
	if event is teCombatEventTurnStarted:
		turn_queue.push_back(turn_queue.pop_front())
	if event is teCombatEventUnitAttacked:
		units[event.unit_id].hp -= event.damage


func is_finished() -> bool:
	return false


func current_unit_id() -> int:
	return turn_queue.front()


func all_units_id() -> Array[int]:
	return units.keys()


func unit(unit_id: int) -> teCombatUnitState:
	return units[unit_id]


func unit_team_id(unit_id: int) -> int:
	return unit_teams[unit_id]


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
