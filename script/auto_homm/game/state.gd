class_name teGameState extends Resource


@export var unit_roster := teCombatUnitRoster.new()
@export var squad := teGameSquad.new()
@export var hero_id := -1
@export var current_team := teCombatTeam.new()
@export var enemy := teCombatTeam.new()
