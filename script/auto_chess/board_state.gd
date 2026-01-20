@tool
class_name acBoardState extends Resource


#var width: int
#var height: int
@export var tiles : Dictionary[Vector2i, acTileState] = {}
@export var units : Dictionary[Vector2i, acUnitState] = {}
