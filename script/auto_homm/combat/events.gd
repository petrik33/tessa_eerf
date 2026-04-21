class_name teCombatEvents


func _init() -> void:
	Utils.assert_static_lib()


static func unit_attacked(unit_id: int, attacker_id: int, damage: int, is_lethal: bool) -> teCombatEventUnitAttacked:
	var hit := teCombatEventUnitAttacked.new()
	hit.attacker_id = attacker_id
	hit.unit_id = unit_id
	hit.damage = damage
	hit.lethal = is_lethal
	return hit

static func unit_damaged(unit_id: int, damage: int) -> teCombatEventUnitDamaged:
	var event := teCombatEventUnitDamaged.new()
	event.unit_id = unit_id
	event.damage = damage
	return event

static func unit_died(unit_id: int) -> teCombatEventUnitDied:
	var event := teCombatEventUnitDied.new()
	event.unit_id = unit_id
	return event

static func unit_moved(unit_id: int, path: Array[Vector2i]) -> teCombatEventUnitMoved:
	var event := teCombatEventUnitMoved.new()
	event.unit_id = unit_id
	event.path = path
	return event

static func turn_started() -> teCombatEventTurnStarted:
	return teCombatEventTurnStarted.new()

static func turn_finished() -> teCombatEventTurnFinished:
	return teCombatEventTurnFinished.new()

static func initiative_progressed(progress: float) -> teCombatEventInitiativeProgressed:
	var event := teCombatEventInitiativeProgressed.new()
	event.progress = progress
	return event

static func initiative_taken(unit_id: int) -> teCombatEventInitiativeTaken:
	var event := teCombatEventInitiativeTaken.new()
	event.unit_id = unit_id
	return event

static func mana_gained(unit_id: int, mana: int) -> teCombatEventManaGained:
	var event := teCombatEventManaGained.new()
	event.unit_id = unit_id
	event.mana = mana
	return event
