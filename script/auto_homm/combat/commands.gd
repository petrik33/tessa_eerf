class_name teCombatCommands


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func unit_attack(unit_id: int, target_id: int) -> teCombatCommandUnitAttack:
	var command := teCombatCommandUnitAttack.new()
	command.unit_id = unit_id
	command.target_id = target_id
	return command

static func start_combat() -> teCombatCommandStart:
	return teCombatCommandStart.new()
