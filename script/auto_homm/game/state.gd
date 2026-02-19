class_name teGameState extends Resource


@export var all_units: Array[teCombatUnit] = []
@export var squad := teGameSquad.new()
@export var current_team := teCombatTeam.new()
@export var enemy := teCombatTeam.new()
