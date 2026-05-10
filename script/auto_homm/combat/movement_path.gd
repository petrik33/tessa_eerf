class_name teCombatMovementPath extends Resource


@export var from: Vector2i
@export var through: Array[Vector2i] = []


func _init(from_hex: Vector2i, through_path: Array[Vector2i]) -> void:
	from = from_hex
	through = through_path


func destination() -> Vector2i:
	return through.back()


func length() -> int:
	return through.size()


func limit(limited_length: int):
	through = through.slice(0, limited_length + 1)


func is_valid() -> bool:
	return length() > 0
