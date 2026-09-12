@abstract
class_name teCombatTargetQueryBase extends Resource


@abstract
func iter(state: teCombatState, unit_id: int) -> Iter


func collect(state: teCombatState, unit_id: int) -> Array[teCombatTargetBase]:
	var targets: Array[teCombatTargetBase] = []
	for target in iter(state, unit_id):
		targets.push_back(target)
	return targets


@abstract
class Iter:
	@abstract
	func _iter_init(_arg) -> bool

	@abstract
	func _iter_next(_arg) -> bool

	@abstract
	func _iter_get(_arg) -> teCombatTargetBase
