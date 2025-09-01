class_name CombatVisualUnitActionWalk extends CombatVisualUnitActionBase

@export var path: Array[Vector2]

func _init() -> void:
	id = CombatVisualActionID.WALK
