@tool
class_name CombatCommands


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func move_unit(id_path: PackedInt64Array) -> CombatCommandMoveUnit:
	var command = CombatCommandMoveUnit.new()
	command.id_path = id_path
	return command


static func melee_attack_unit(move_id_path: PackedInt64Array, attacked_hex: Vector2i) -> CombatCommandMeleeAttackUnit:
	var command = CombatCommandMeleeAttackUnit.new()
	command.attacked_hex = attacked_hex
	command.move_id_path = move_id_path
	return command


static func ranged_attack_unit(from: Vector2i, to: Vector2i) -> CombatCommandRangedAttackUnit:
	var command = CombatCommandRangedAttackUnit.new()
	command.from = from
	command.to = to
	return command


static func defend() -> CombatCommandUnitDefend:
	return CombatCommandUnitDefend.new()


static func wait() -> CombatCommandUnitWait:
	return CombatCommandUnitWait.new()
