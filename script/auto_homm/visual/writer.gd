class_name teVisualWriter extends teVisualWriterBase


@export var unit_profiles: Dictionary[StringName, teVisualUnitProfile]


@export var freeze_frame_duration_hit := 0.33
@export var freeze_frame_duration_kill := 0.74


func intro(_initial_state: teCombatState) -> teVisualSequence:
	return null


func sequence(
	state: teCombatState,
	action: teCombatActionBase,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	if action is teCombatActionUnitAttack:
		return write_attack(
			state,
			action,
			context,
			events_buffer,
		)
	if action is teCombatActionUnitMove:
		return write_unit_move(action, state, events_buffer)
	return teVisualActions.emit(events_buffer, state)


func write_unit_move(
	action: teCombatActionUnitMove,
	state: teCombatState,
	events_buffer: teCombatEventsBuffer
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
		teVisualActions.emit(events_buffer, state)
	)


func write_attack(
	state: teCombatState,
	action: teCombatActionUnitAttack,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	var attacker := state.unit(action.unit_id)
	if not attacker:
		return null
	var attack_kind := get_attack_kind(attacker)
	var is_lethal := events_buffer.events.find_custom(func (ev): return ev is teCombatEventUnitDied) != -1
	return teVisualActions.sub_sequence(
		write_attack_windup(action.unit_id, attack_kind, context),
		write_attack_post_windup(attacker, action.unit_id, action.target_id, attack_kind),
		teVisualActions.parallel(
			teVisualActions.unit_flash(action.target_id),
			teVisualActions.unit_act(
				action.target_id,
				teVisualActs.DIE if is_lethal else teVisualActs.GET_HURT,
				teVisualActs.GET_HURT,
				true
			),
			teVisualActions.emit(events_buffer, state)
		),
		teVisualActions.freeze_frame(freeze_frame_duration_kill if is_lethal else freeze_frame_duration_hit),
	)


func write_attack_windup(
	attacker_id: int,
	attack_kind: teVisualUnitProfile.AttackKind,
	context: Context
) -> teVisualActionBase:
	var attack_act := get_attack_act(attack_kind)
	var combo_hit_idx = context.read_or(teCombatContext.COMBO_HIT, -1)
	var is_combo: bool = combo_hit_idx != -1
	if not is_combo:
		return teVisualActions.unit_windup(attacker_id, attack_act)
	var combo_length = context.read_or(teCombatContext.COMBO_LENGTH, 1)
	return teVisualActions.unit_combo(
		attacker_id, attack_act,
		combo_hit_idx, combo_length
	)


func write_attack_post_windup(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualUnitProfile.AttackKind
) -> teVisualActionBase:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return null
		teVisualUnitProfile.AttackKind.PROJECTILE:
			return teVisualActions.unit_shoot_projectile(
				attacker_id,
				target_id,
				attacker.definition_uid
			)
		teVisualUnitProfile.AttackKind.CAST:
			return teVisualActions.vfx_on_target(
				attacker.definition_uid,
				target_id,
			)
	return null


func get_attack_act(attack_kind: teVisualUnitProfile.AttackKind) -> StringName:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return teVisualActs.MELEE
		teVisualUnitProfile.AttackKind.PROJECTILE:
			return teVisualActs.RANGED
		teVisualUnitProfile.AttackKind.CAST:
			return teVisualActs.CAST
	return ""


func get_attack_kind(attacker: teCombatUnitState) -> teVisualUnitProfile.AttackKind:
	var attacker_profile: teVisualUnitProfile = unit_profiles.get(attacker.definition_uid)
	if attacker_profile == null:
		return teVisualUnitProfile.AttackKind.MELEE
	else:
		return attacker_profile.attack
