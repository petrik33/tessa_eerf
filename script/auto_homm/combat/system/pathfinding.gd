class_name teCombatPathfinding


func _init() -> void:
	Utils.assert_static_lib()


static func path_to_hex(runtime: teCombatRuntime, unit: teCombatUnitState, hex: Vector2i) -> teCombatMovementPath:
	var path := runtime.services.navigation.get_path(unit.hex, hex)
	return teCombatMovementPath.new(unit.hex, path)


static func path_to_attack(runtime: teCombatRuntime, unit: teCombatUnitState, target: teCombatUnitState) -> teCombatMovementPath:
	var path := runtime.services.navigation.bfs(
		unit.hex,
		func(hex): return HexMath.distance(hex, target.hex) <= unit.stats.attack_range
	)
	return teCombatMovementPath.new(unit.hex, path)
	
