class_name CombatCommandMoveUnit extends CombatCommandBase

@export var id_path: PackedInt64Array

func target_hex_id() -> int:
	return id_path[-1]
