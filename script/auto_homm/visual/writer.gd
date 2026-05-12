class_name teVisualWriter extends teVisualWriterBase


@export var board: teBoardVisual


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
	var attack_kind: teVisualUnitProfile.AttackKind
	var attacker_profile: teVisualUnitProfile = unit_profiles.get(attacker.definition_uid)
	if attacker_profile == null:
		attack_kind = teVisualUnitProfile.AttackKind.MELEE
	else:
		attack_kind = attacker_profile.attack
	var combo_hit_idx = context.read_or(teCombatContext.COMBO_HIT, -1)
	var combo_hits = context.read_or(teCombatContext.COMBO_LENGTH, 1)
	if combo_hit_idx == -1 or combo_hits == 1:
		return write_single_attack(
			attacker,
			action.unit_id,
			action.target_id,
			attack_kind,
			events_buffer,
			state
		)
	if combo_hit_idx == 0:
		return write_first_combo_attack(
			attacker,
			action.unit_id,
			action.target_id,
			attack_kind,
			combo_hits,
			events_buffer,
			state
		)
	if combo_hit_idx == combo_hits - 1:
		return write_last_combo_attack(
			attacker,
			action.unit_id,
			action.target_id,
			attack_kind,
			combo_hits,
			events_buffer,
			state
		)
	return write_combo_attack(
		attacker,
		action.unit_id,
		action.target_id,
		attack_kind,
		combo_hit_idx,
		combo_hits,
		events_buffer,
		state
	)


func write_single_attack(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualUnitProfile.AttackKind,
	events_buffer: teCombatEventsBuffer,
	state: teCombatState
) -> teVisualActionBase:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_act(
					attacker_id,
					teVisualActs.MELEE
				),
				write_attack_impact(target_id, events_buffer, state, true)
			)
		teVisualUnitProfile.AttackKind.PROJECTILE:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_act(
					attacker_id,
					teVisualActs.RANGED
				),
				teVisualActions.sub_sequence(
					teVisualActions.unit_shoot_projectile(
						attacker_id,
						target_id,
						attacker.definition_uid
					),
					write_attack_impact(target_id, events_buffer, state)
				)
			)
		teVisualUnitProfile.AttackKind.CAST:
			return teVisualActions.unit_windup_sequence(
				teVisualActions.unit_act(
					attacker_id,
					teVisualActs.CAST
				),
				teVisualActions.sub_sequence(
					teVisualActions.vfx_on_target(
						attacker.definition_uid,
						target_id,
					),
					write_attack_impact(target_id, events_buffer, state)
				)
			)
	return null


func write_first_combo_attack(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualUnitProfile.AttackKind,
	attacks_number: int,
	events_buffer: teCombatEventsBuffer,
	state: teCombatState
) -> teVisualActionBase:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return teVisualActions.parallel(
				teVisualActions.unit_act(
					attacker_id,
					teVisualActs.combo_act(teVisualActs.MELEE, attacks_number),
					true,
					false
				),
				teVisualActions.sub_sequence(
					teVisualActions.wait_unit_windup(
						attacker_id,
						teVisualActs.combo_windup(teVisualActs.MELEE, attacks_number, 0)
					),
					write_attack_impact(target_id, events_buffer, state, false)
				)
			)
	return null


func write_combo_attack(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualUnitProfile.AttackKind,
	attacks_idx: int,
	attacks_number: int,
	events_buffer: teCombatEventsBuffer,
	state: teCombatState,
) -> teVisualActionBase:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return teVisualActions.sub_sequence(
				teVisualActions.wait_unit_windup(
					attacker_id,
					teVisualActs.combo_windup(teVisualActs.MELEE, attacks_number, attacks_idx)
				),
				write_attack_impact(target_id, events_buffer, state, false)
			)
	return null


func write_last_combo_attack(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualUnitProfile.AttackKind,
	attacks_number: int,
	events_buffer: teCombatEventsBuffer,
	state: teCombatState,
) -> teVisualActionBase:
	match attack_kind:
		teVisualUnitProfile.AttackKind.MELEE:
			return teVisualActions.sub_sequence(
				teVisualActions.wait_unit_windup(
					attacker_id,
					teVisualActs.combo_last_windup(teVisualActs.MELEE, attacks_number)
				),
				write_attack_impact(target_id, events_buffer, state, true)
			)
	return null


func write_attack_impact(
	target_id: int,
	events_buffer: teCombatEventsBuffer,
	state: teCombatState,
	wait := true
) -> teVisualActionBase:
	var is_lethal := events_buffer.events.find_custom(func (ev): return ev is teCombatEventUnitDied) != -1
	return teVisualActions.parallel(
		teVisualActions.unit_flash(target_id, wait),
		hit_action(target_id, is_lethal, wait),
		teVisualActions.freeze_frame(
			freeze_frame_duration_kill if is_lethal else freeze_frame_duration_hit
		),
		teVisualActions.emit(events_buffer, state)
	)


func hit_action(unit_id: int, is_lethal: bool, wait_hurt := true) -> teVisualActionBase:
	if not is_lethal:
		return teVisualActions.unit_act(
			unit_id,
			teVisualActs.GET_HURT,
			true,
			wait_hurt,
			true
		)
	else:
		return teVisualActions.unit_die(unit_id)
