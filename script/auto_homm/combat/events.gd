class_name teCombatEvents


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func unit_attacked(unit_id: int, attacker_id: int, damage: int, is_lethal: bool) -> teCombatEventUnitAttacked:
	var hit := teCombatEventUnitAttacked.new()
	hit.attacker_id = attacker_id
	hit.unit_id = unit_id
	hit.damage = damage
	hit.lethal = is_lethal
	return hit


static func turn_started() -> teCombatEventTurnStarted:
	return teCombatEventTurnStarted.new()


static func turn_finished() -> teCombatEventTurnFinished:
	return teCombatEventTurnFinished.new()
