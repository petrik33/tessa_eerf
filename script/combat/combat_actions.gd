@tool
class_name CombatActions


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func move(state: CombatState, services: CombatServices, id_path: PackedInt64Array) -> CombatActionMove:
	return CombatActionMove.new(
		state.current_unit_handle(),
		services.navigation.path(id_path)
	)
	
	
static func melee_attack(
	attacking: CombatUnitHandle, 
	defending: CombatUnitHandle,
	from_hex: Vector2i,
	damage: int
) -> CombatActionMeleeAttack:
	var action := CombatActionMeleeAttack.new()
	action.attacking = attacking
	action.defending = defending
	action.from_hex = from_hex
	action.damage = damage
	return action


static func ranged_attack(
	attacking: CombatUnitHandle, 
	target: CombatUnitHandle,
	damage: int
) -> CombatActionRangedAttack:
	var action := CombatActionRangedAttack.new()
	action.attacking = attacking
	action.target = target
	action.damage = damage
	return action
