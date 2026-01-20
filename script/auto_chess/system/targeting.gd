@tool
class_name acTargeting


func _init() -> void:
	assert(false, "Can't be constructed")


enum Mode {
	NEAREST,
	LOWEST_HP,
	HIGHEST_THREAT,
	RANDOM,
	FURTHEST,
	FRONTLINE_FIRST
}


static func find(unit: acUnitState, battle: acBattleState) -> acUnitState:
	var enemies := battle.teams[1 - unit.team]
	var best = null
	var best_score := INF

	for other in enemies.units:
		if not other.alive:
			continue
		var d := HexMath.distance(unit.hex, other.hex)
		if d <= unit.definition.attack_range:
			if d < best_score:
				best_score = d
				best = other
	return best
