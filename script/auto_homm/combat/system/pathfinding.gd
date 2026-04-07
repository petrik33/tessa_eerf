class_name teCombatPathfinding


func _init() -> void:
	Utils.assert_static_lib()


static func path_to_attack(runtime: teCombatRuntime, unit: teCombatUnitState, target: teCombatUnitState) -> Array[Vector2i]:
	return runtime.services.navigation.bfs(
		unit.hex, 
		func(hex): return HexMath.distance(hex, target.hex) <= unit.stats.attack_range
	)
	
