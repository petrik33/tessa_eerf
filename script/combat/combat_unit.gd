class_name CombatUnit extends Resource

@export var unit: Unit
@export var placement: Vector2i
@export var army_handle: CombatArmyHandle
@export var stack_size: int
@export var hp: int


func movement_range() -> int:
	return stats().speed


func stats() -> UnitCombatStats:
	return unit.combat_stats


func is_an_ally(ally_army_handle: CombatArmyHandle) -> bool:
	return army_handle.is_equal(ally_army_handle)


func is_an_enemy(ally_army_handle: CombatArmyHandle) -> bool:
	return not army_handle.is_equal(ally_army_handle)
