@abstract
class_name teCombatTargetHexQueryBase extends Resource


@abstract
func iter(state: teCombatState, context: Context) -> Iter


@abstract
class Iter:
	@abstract
	func _iter_init(_arg) -> bool

	@abstract
	func _iter_next(_arg) -> bool

	@abstract
	func _iter_get(_arg) -> teCombatTargetHex
