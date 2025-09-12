class_name CombatVisualActions


const IDLE := &"idle"
const WALK := &"walk"
const MELEE := &"melee"
const RANGED := &"ranged"
const HURT := &"hurt"
const DEATH := &"death"


func _init() -> void:
	assert(false, "Library class not supposed to be created")


static func walk(unit_handle: CombatUnitHandle, path: Array[Vector2]) -> CombatVisualUnitActionWalk:
	var action = CombatVisualUnitActionWalk.new()
	action.unit_handle = unit_handle
	action.path = path
	return action


static func idle(unit_handle: CombatUnitHandle, position: Vector2, direction: float) -> CombatVisualUnitActionGoIdle:
	var action = CombatVisualUnitActionGoIdle.new()
	action.unit_handle = unit_handle
	action.position = position
	action.enemy_direction = direction
	return action
