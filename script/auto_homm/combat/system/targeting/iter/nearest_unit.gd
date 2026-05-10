class_name teCombatTargetingNearestUnitIter extends teCombatTargetUnitQueryBase.Iter


var sorted: Array[int]
var idx: int


func _init(state: teCombatState, units_id: Array[int], unit_id: int) -> void:
	var unit := state.unit(unit_id)
	sorted = units_id.duplicate()
	sorted.sort_custom(func(id_a, id_b):
		var unit_a := state.unit(id_a)
		var unit_b := state.unit(id_b)
		var distance_a := HexMath.distance(unit_a.hex, unit.hex)
		var distance_b := HexMath.distance(unit_b.hex, unit.hex)
		return distance_a < distance_b
	)


func _iter_init(_arg) -> bool:
	idx = 0
	return not sorted.is_empty()


func _iter_next(_arg) -> bool:
	idx += 1
	return idx < sorted.size()


func _iter_get(_arg) -> teCombatTargetUnit:
	return teCombatTargets.unit(sorted[idx])
