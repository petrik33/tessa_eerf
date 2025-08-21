class_name CombatVisualActions

func _init() -> void:
	assert(false, "Library class not supposed to be created")
	
static func walk(unit_idx: int, path: Array[Vector2]) -> CombatVisualUnitActionWalk:
	var action = CombatVisualUnitActionWalk.new()
	action.unit_idx = unit_idx
	action.path = path
	return action

static func idle(unit_idx: int, position: Vector2, direction: float) -> CombatVisualUnitActionGoIdle:
	var action = CombatVisualUnitActionGoIdle.new()
	action.unit_idx = unit_idx
	action.position = position
	action.enemy_direction = direction
	return action
