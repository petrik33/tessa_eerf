class_name teCombatUnitState extends Resource


@export var hp: int
@export var mana: int
@export var hex: Vector2i


func is_alive() -> bool:
	return hp > 0
