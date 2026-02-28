class_name teVisualWriter extends Resource


func intro(initial_state: teCombatState) -> teVisualSequence:
	return null


func sequence(log: teCombatEventLog) -> teVisualSequence:
	var written_sequence := teVisualSequence.new()
	for event in log.events:
		var action := write(event)
		if action == null:
			continue
		written_sequence.actions.push_back(action)
	return written_sequence


func write(event: teCombatEventBase) -> teVisualActionBase:
	if event is teCombatEventUnitMeleeHit:
		return teVisualActions.unit_windup_sequence(
			teVisualActions.unit_sequence(
				event.attacker_id,
				teVisualActs.melee()
			),
			teVisualActions.unit_sequence(
				event.unit_id,
				on_hit_act(event.lethal)
			)
		)
	return null


func on_hit_act(is_lethal: bool) -> teVisualActBase:
	return teVisualActs.die() if is_lethal else teVisualActs.get_hurt()
