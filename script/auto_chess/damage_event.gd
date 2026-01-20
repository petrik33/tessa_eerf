@tool
class_name acDamageEvent extends Resource


@export var source: acUnitState
@export var target: acUnitState
@export var base_damage: int
@export var damage_type: acDamage.Type
@export var is_crit := false
@export var tags: Array[StringName] = []
