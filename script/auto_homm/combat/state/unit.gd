class_name teCombatUnitState extends Resource


@export var hp: int
@export var mana: int
@export var hex: Vector2i
@export var definition_uid: StringName


func is_alive() -> bool:
	return hp > 0
