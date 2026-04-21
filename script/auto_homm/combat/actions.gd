class_name teCombatActions


func _init() -> void:
	Utils.assert_static_lib()


static func unit_attack(unit_id: int, taget_id: int) -> teCombatActionUnitAttack:
	var action := teCombatActionUnitAttack.new()
	action.unit_id = unit_id
	action.target_id = taget_id
	return action


static func unit_move(unit_id: int, movement_path: teCombatMovementPath) -> teCombatActionUnitMove:
	var action := teCombatActionUnitMove.new()
	action.unit_id = unit_id
	action.path = movement_path
	return action


static func initiative_advance() -> teCombatActionInitiativeAdvance:
	return teCombatActionInitiativeAdvance.new()
