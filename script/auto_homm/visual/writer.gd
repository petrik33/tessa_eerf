class_name teVisualWriter extends teVisualWriterBase


@export var unit_profiles: Dictionary[StringName, teVisualUnitProfile]


@export var freeze_frame_duration_hit := 0.33
@export var freeze_frame_duration_kill := 0.74


func intro(_initial_state: teCombatState) -> teVisualSequence:
	return null


func sequence(state: teCombatState, event_log: teCombatEventLog) -> teVisualSequence:
	var written_sequence := teVisualSequence.new()
	for event in event_log.events:
		var action := write(state, event)
		if action == null:
			continue
		written_sequence.actions.push_back(action)
	return written_sequence


func write(state: teCombatState, event: teCombatEventBase) -> teVisualActionBase:
	if event is teCombatEventUnitAttacked:
		return write_attack(state, event)
	return null


func write_attack(state: teCombatState, event: teCombatEventUnitAttacked) -> teVisualActionBase:
	var attacker := state.unit(event.attacker_id)
	if not attacker:
		return null
	var attack_kind: teVisualUnitProfile.AttackKind
	var attacker_profile: teVisualUnitProfile = unit_profiles.get(attacker.definition_uid)
	if attacker_profile == null:
		attack_kind = teVisualUnitProfile.AttackKind.MELEE
	else:
		attack_kind = attacker_profile.attack
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE: 
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_sequence(
					event.attacker_id,
					teVisualActs.melee()
				),
				write_attack_impact(event)
			)
		teVisualUnitProfile.AttackKind.PROJECTILE:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_sequence(
					event.attacker_id,
					teVisualActs.ranged()
				),
				teVisualActions.sub_sequence(
					teVisualActions.unit_shoot_projectile(
						event.attacker_id,
						event.unit_id,
						attacker.definition_uid
					),
					write_attack_impact(event)
				)

			)
		teVisualUnitProfile.AttackKind.CAST:
			pass
	return null


func write_attack_impact(event: teCombatEventUnitAttacked) -> teVisualActionBase:
	return teVisualActions.parallel(
		teVisualActions.unit_flash(event.unit_id),
		hit_action(event.unit_id, event.lethal),
		teVisualActions.freeze_frame(
			freeze_frame_duration_kill if event.lethal else freeze_frame_duration_hit
		),
		teVisualActions.emit(event)
	)


func hit_action(unit_id: int, is_lethal: bool) -> teVisualActionBase:
	if not is_lethal:
		return teVisualActions.unit_sequence(
			unit_id,
			teVisualActs.get_hurt()
		)
	else:
		return teVisualActions.unit_die(unit_id)
