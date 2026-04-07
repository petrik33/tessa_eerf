class_name teCombatState extends Resource


@export var map: teCombatMap
@export var units: Dictionary[int, teCombatUnitState]
@export var unit_teams: Dictionary[int, int]
@export var initiative_holder_id: int = -1
@export var active_unit_moved: bool


static func from(setup: teCombatSetup, unit_set: teUnitSet, unit_roster: teCombatUnitRoster) -> teCombatState:
	var state := teCombatState.new()
	state.map = setup.map.duplicate()
	var team_id := 0
	for team in setup.teams:
		for unit_id in team.units_placement:
			var placed_unit := unit_roster.get_unit(unit_id)
			var unit_initial_state := teCombatUnitState.new()
			var unit_definition := unit_set.get_definition(placed_unit.definition_uid)
			unit_initial_state.hex = team.units_placement[unit_id]
			unit_initial_state.hp_spent = 0
			unit_initial_state.mana_collected = 0
			unit_initial_state.initiative_progress = 0.0
			unit_initial_state.stats = unit_definition.base_stats.duplicate()
			unit_initial_state.definition_uid = placed_unit.definition_uid
			state.units[unit_id] = unit_initial_state
			state.unit_teams[unit_id] = team_id
		team_id += 1
	return state


func turn_in_progress() -> bool:
	return active_unit_moved


func active_unit() -> teCombatUnitState:
	if initiative_holder_id == -1:
		return null
	return unit(initiative_holder_id)


func update(turn_log: teCombatTurnLog):
	for event in turn_log.events:
		apply_event(event)


func apply_event(event: teCombatEventBase):
	if event is teCombatEventTurnStarted:
		active_unit_moved = false
	if event is teCombatEventUnitAttacked:
		units[event.unit_id].hp_spent = min(
			units[event.unit_id].hp_spent + event.damage,
			units[event.unit_id].stats.max_hp
		)
		if event.lethal:
			units.erase(event.unit_id)
			unit_teams.erase(event.unit_id)
	if event is teCombatEventInitiativeProgressed:
		for id in units:
			units[id].initiative_progress += event.progress
	if event is teCombatEventInitiativeTaken:
		initiative_holder_id = event.unit_id
		units[initiative_holder_id].initiative_progress = 0
	if event is teCombatEventUnitMoved:
		units[event.unit_id].hex = event.path.back()
		active_unit_moved = true
		


func is_finished() -> bool:
	return false


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
