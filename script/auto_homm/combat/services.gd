class_name teCombatServices extends RefCounted


var navigation: HexNavigationContext
var pathfinding: HexPathfinding


func _init(setup: teCombatSetup):
	navigation = HexNavigationContext.new(setup.map.grid)
	pathfinding = HexPathfinding.new(navigation)
	for team in setup.teams:
		for hex in team.placement:
			pathfinding.set_point_disabled(hex)


func sync(state: teCombatState):
	pass


func update(log: teCombatEventLog):
	pass
