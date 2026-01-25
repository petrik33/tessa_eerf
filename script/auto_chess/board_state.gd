@tool
class_name acBoardState extends Resource


@export var tiles : Dictionary[Vector2i, acTileState] = {}
@export var units : Dictionary[Vector2i, acUnitState] = {}


func reserve_hex(hex: Vector2i, unit: acUnitState):
	pass


func release_hex(hex: Vector2i):
	pass


func is_walkable(hex: Vector2i) -> bool:
	return true
