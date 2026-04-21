class_name teCombatMovementPath extends Resource


@export var from: Vector2i
@export var through: Array[Vector2i] = []


func _init(from_hex: Vector2i, through_path: Array[Vector2i] = []) -> void:
	from = from_hex
	through = through_path


func destination() -> Vector2i:
	return from if through.is_empty() else through.back()


func length() -> int:
	return through.size()
