class_name teCombatCommands


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func melee(unit_id: int, target_id: int) -> teCombatCommandUnitMeleeAttack:
	var command := teCombatCommandUnitMeleeAttack.new()
	command.unit_id = unit_id
	command.target_id = target_id
	return command
