class_name teCombatServices extends RefCounted


var navigation: HexNavigationContext
var pathfinding: HexPathfinding


func _init(setup: teCombatSetup):
	navigation = HexNavigationContext.new(setup.map.grid)
	pathfinding = HexPathfinding.new(navigation)
	for team in setup.teams:
		for unit_id in team.units_placement:
			pathfinding.set_point_disabled(team.units_placement[unit_id])


func sync(state: teCombatState):
	pass


func update(log: teCombatEventLog):
	pass
