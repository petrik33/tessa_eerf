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
	action.id = WALK
	return action


static func idle(unit_handle: CombatUnitHandle, position: Vector2, direction: float) -> CombatVisualUnitActionGoIdle:
	var action = CombatVisualUnitActionGoIdle.new()
	action.unit_handle = unit_handle
	action.position = position
	action.enemy_direction = direction
	action.id = IDLE
	return action
	
	
static func melee(unit_handle: CombatUnitHandle, position: Vector2) -> CombatVisualUnitActionMelee:
	var action := CombatVisualUnitActionMelee.new()
	action.unit_handle = unit_handle
	action.attacked_position = position
	action.id = MELEE
	return action
	
	
static func hurt(unit_handle: CombatUnitHandle) -> CombatVisualUnitActionHurt:
	var action := CombatVisualUnitActionHurt.new()
	action.unit_handle = unit_handle
	action.id = HURT
	return action
