class_name teCombatTeam extends Resource


## Key is unit id and value is the hex where it's placed
@export var units_placement: Dictionary[int, Vector2i]


func unit_id_at_hex(hex: Vector2i) -> int:
	for unit_id in units_placement:
		if units_placement[unit_id] == hex:
			return unit_id
	return -1
