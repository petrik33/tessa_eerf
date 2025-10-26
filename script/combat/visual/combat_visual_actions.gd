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


static func idle(unit_handle: CombatUnitHandle, position: Vector2, direction: Vector2) -> CombatVisualUnitActionGoIdle:
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


static func ranged(unit_handle: CombatUnitHandle, target: Vector2) -> CombatVisualUnitActionRanged:
	var action := CombatVisualUnitActionRanged.new()
	action.unit_handle = unit_handle
	action.id = RANGED
	action.target = target
	return action


static func parallel(... actions: Array) -> CombatParallelVisualActions:
	var action := CombatParallelVisualActions.new()
	action.actions = []
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action


static func sub_sequence(... actions: Array) -> CombatVisualActionsSubSequence:
	var action := CombatVisualActionsSubSequence.new()
	action.actions = []
	for sub_action in actions:
		action.actions.push_back(sub_action)
	return action


static func projectile(unit_handle: CombatUnitHandle, target: Vector2) -> CombatVisualActionShootUnitProjectile:
	var action := CombatVisualActionShootUnitProjectile.new()
	action.shooting_unit = unit_handle
	action.target = target
	return action


static func wait_unit_trigger(unit_handle: CombatUnitHandle) -> CombatVisualActionWaitUnitTrigger:
	var action := CombatVisualActionWaitUnitTrigger.new()
	action.unit_handle = unit_handle
	return action


static func unit_trigger(unit_action: CombatVisualUnitActionBase, post_trigger: CombatVisualActionBase):
	return parallel(
		sub_sequence(wait_unit_trigger(unit_action.unit_handle), post_trigger),
		unit_action
	)


static func ranged_unit_projectile(unit: CombatUnitHandle, target: Vector2) -> CombatVisualActionBase:
	return unit_trigger(
		ranged(unit, target),
		projectile(unit, target)
	)
