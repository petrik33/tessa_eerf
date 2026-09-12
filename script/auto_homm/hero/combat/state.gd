class_name teHeroCombatState extends Resource


@export var heroes_id: Array[int]


func is_hero(unit_id: int) -> bool:
	return heroes_id.has(unit_id)
