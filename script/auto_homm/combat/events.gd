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


static func mana_spent(unit_id: int, mana: int) -> teCombatEventManaSpent:
	var event := teCombatEventManaSpent.new()
	event.unit_id = unit_id
	event.amount = mana
	return event


static func next_attack_modifier_consumed(unit_id: int) -> teCombatEventUnitNextAttackModifierConsumed:
	var event := teCombatEventUnitNextAttackModifierConsumed.new()
	event.unit_id = unit_id
	return event


static func next_attack_modified(unit_id: int, pattern: teCombatAttackPatternBase) -> teCombatEventUnitNextAttackModified:
	var event := teCombatEventUnitNextAttackModified.new()
	event.unit_id = unit_id
	event.next_attack_pattern = pattern
	return event


static func effect_consumed(unit_id: int, effect_id: int) -> teCombatEventEffectConsumed:
	var event := teCombatEventEffectConsumed.new()
	event.unit_id = unit_id
	event.effect_id = effect_id
	return event


static func effect_finished(unit_id: int, effect_id: int) -> teCombatEventEffectFinished:
	var event := teCombatEventEffectFinished.new()
	event.unit_id = unit_id
	event.effect_id = effect_id
	return event


static func effect_applied(unit_id: int, effect_id: int, effect: teCombatEffectInstance) -> teCombatEventEffectApplied:
	var event := teCombatEventEffectApplied.new()
	event.unit_id = unit_id
	event.effect_id = effect_id
	event.effect = effect
	return event
