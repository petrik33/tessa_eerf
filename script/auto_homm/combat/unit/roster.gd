class_name teCombatUnitRoster extends Resource


@export var all_units: Array[teCombatUnit]


func get_unit(unit_id: int) -> teCombatUnit:
	return all_units[unit_id]
