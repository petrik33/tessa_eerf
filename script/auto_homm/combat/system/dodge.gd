class_name teCombatDodge


func _init() -> void:
	Utils.assert_static_lib()


static func check(attacker_id: int, target_id: int, runtime: teCombatRuntime, state: teCombatState):
	return false
