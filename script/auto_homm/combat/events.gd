class_name teCombatEvents


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func unit_melee_hit(unit_id: int, attacker_id: int, damage: int, is_lethal: bool) -> teCombatEventBase:
	var hit := teCombatEventUnitMeleeHit.new()
	hit.attacker_id = attacker_id
	hit.unit_id = unit_id
	hit.damage = damage
	hit.lethal = is_lethal
	return hit


static func progress_turn() -> teCombatEventBase:
	return teCombatEventTurnProgressed.new()
