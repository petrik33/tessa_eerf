@tool
class_name CombatCommands

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")
	
static func move_unit(id_path: PackedInt64Array) -> CombatCommandMoveUnit:
	var command = CombatCommandMoveUnit.new()
	command.id_path = id_path
	return command

static func attack_unit(move_id_path: PackedInt64Array, attacked_hex: Vector2i) -> CombatCommandAttackUnit:
	var command = CombatCommandAttackUnit.new()
	command.attacked_hex = attacked_hex
	command.move_id_path = move_id_path
	return command
