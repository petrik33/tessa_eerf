class_name teVisualWriter extends teVisualWriterBase


@export var unit_profiles: Dictionary[StringName, teVisualUnitProfile]


@export var freeze_frame_duration_hit := 0.33
@export var freeze_frame_duration_kill := 0.74


func intro(_initial_state: teCombatState) -> teVisualSequence:
	return null


func sequence(
	state: teCombatState,
	action: teCombatActionBase,
	events: Array[teCombatEventBase]
) -> teVisualActionBase:
	if action is teCombatActionUnitAttack:
		return write_attack(state, action, events)
	if action is teCombatActionUnitMove:
		return write_unit_move(action, events)
	return null


func write_unit_move(
	action: teCombatActionUnitMove,
	events: Array[teCombatEventBase]
) -> teVisualActionBase:
	var visual_path := action.path.through.duplicate()
	visual_path.insert(0, action.path.from)
	return teVisualActions.sub_sequence(
		teVisualActions.unit_move(
			action.unit_id,
			visual_path
		),
		teVisualActions.unit_go_idle(
			action.unit_id
		),
		teVisualActions.emit_all(events)
	)


func write_attack(
	state: teCombatState,
	action: teCombatActionUnitAttack,
	events: Array[teCombatEventBase]
) -> teVisualActionBase:
	var attacker := state.unit(action.unit_id)
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
				teVisualActions.unit_act(
					action.unit_id,
					teVisualActs.MELEE
				),
				write_attack_impact(action, events)
			)
		teVisualUnitProfile.AttackKind.PROJECTILE:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_act(
					action.unit_id,
					teVisualActs.RANGED
				),
				teVisualActions.sub_sequence(
					teVisualActions.unit_shoot_projectile(
						action.unit_id,
						action.target_id,
						attacker.definition_uid
					),
					write_attack_impact(action, events)
				)
			)
		teVisualUnitProfile.AttackKind.CAST:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_act(
					action.unit_id,
					teVisualActs.CAST
				),
				teVisualActions.sub_sequence(
					teVisualActions.vfx_on_target(
						attacker.definition_uid,
						action.target_id,
					),
					write_attack_impact(action, events)
				)
			)
	return null


func write_attack_impact(action: teCombatActionUnitAttack, events: Array[teCombatEventBase]) -> teVisualActionBase:
	var is_lethal := events.find_custom(func (ev): return ev is teCombatEventUnitDied) != -1
	return teVisualActions.parallel(
		teVisualActions.unit_flash(action.target_id),
		hit_action(action.target_id, is_lethal),
		teVisualActions.freeze_frame(
			freeze_frame_duration_kill if is_lethal else freeze_frame_duration_hit
		),
		teVisualActions.emit_all(events)
	)


func hit_action(unit_id: int, is_lethal: bool) -> teVisualActionBase:
	if not is_lethal:
		return teVisualActions.unit_act(
			unit_id,
			teVisualActs.GET_HURT
		)
	else:
		return teVisualActions.unit_die(unit_id)
