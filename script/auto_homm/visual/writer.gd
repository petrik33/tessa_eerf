class_name teVisualWriter extends teVisualWriterBase


@export var unit_profiles: Dictionary[StringName, teVisualWritingUnitProfile]


@export var freeze_frame_duration_hit := 0.33
@export var freeze_frame_duration_kill := 0.74

@export var initiative_advance_time_sec := 0.3


func get_unit_profile(uid: StringName) -> teVisualWritingUnitProfile:
	return unit_profiles.get(uid, teVisualWritingUnitProfile.new())


func intro(_initial_state: teCombatState) -> teVisualSequence:
	return null


func sequence(
	state: teCombatState,
	action: teCombatActionBase,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	if action is teCombatActionUnitAttack:
		return write_attack(state, action, context, events_buffer)
	if action is teCombatActionUnitMove:
		return write_unit_move(state, action, events_buffer)
	if action is teCombatActionDamage:
		return write_damage(state, action, events_buffer)
	if action is teCombatActionUnitCastSkill:
		return write_cast(state, action, events_buffer)
	if action is teCombatActionInitiativeAdvance:
		return write_initiative_advance(state, action, context, events_buffer) 
	return teVisualActions.emit(events_buffer, state)


func write_initiative_advance(
	state: teCombatState,
	action: teCombatActionInitiativeAdvance,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	return teVisualActions.sub_sequence(
		teVisualActions.wait(initiative_advance_time_sec),
		teVisualActions.emit(events_buffer, state)
	)


func write_cast(
	state: teCombatState,
	action: teCombatActionUnitCastSkill,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	return teVisualActions.sub_sequence(
		teVisualActions.unit_windup(action.unit_id, teVisualActs.SKILL),
		write_skill_visual(state, action, events_buffer),
		teVisualActions.emit(events_buffer, state),
		teVisualActions.unit_wait_winddown(action.unit_id, teVisualActs.SKILL)
	)


func write_skill_visual(
	state: teCombatState,
	action: teCombatActionUnitCastSkill,
	_events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	var unit := state.unit(action.unit_id)
	var unit_profile := get_unit_profile(unit.definition_uid)
	match unit_profile.skill:
		teVisualWriting.SkillVisual.VFX:
			var unit_target := action.target as teCombatTargetUnit
			if unit_target != null:
				var parallel_vfx := teVisualActions.parallel()
				for unit_id in unit_target.units_id:
					parallel_vfx.actions.push_back(teVisualActions.vfx_on_target(
						teVisualWritingVfx.skill(unit.definition_uid),
						unit_id, {}, unit_profile.skill_socket
					))
				return parallel_vfx
	return null


func write_unit_move(
	state: teCombatState,
	action: teCombatActionUnitMove,
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


func write_damage(
	state: teCombatState,
	action: teCombatActionDamage,
	events_buffer: teCombatEventsBuffer,
	wait_hurt_animation: bool = true
) -> teVisualActionBase:
	var is_lethal := events_buffer.has(func (ev): return ev is teCombatEventUnitDied)
	var parallel_damage := teVisualActions.parallel()
	var parallel_winddown := teVisualActions.parallel()
	for instance in action.instances:
		var hurt_act := teVisualActs.DIE if is_lethal else teVisualActs.GET_HURT
		parallel_damage.actions.push_back(teVisualActions.parallel(
			teVisualActions.unit_flash(instance.target_unit_id),
			teVisualActions.unit_act(
				instance.target_unit_id,
				teVisualActs.DIE if is_lethal else teVisualActs.GET_HURT,
				true
			),
			teVisualActions.emit(events_buffer, state)
		))
		parallel_winddown.actions.push_back(
			teVisualActions.unit_wait_winddown(instance.target_unit_id, hurt_act)
		)
	var sub_sequence := teVisualActions.sub_sequence(
		parallel_damage,
		teVisualActions.freeze_frame(
			freeze_frame_duration_kill if is_lethal else freeze_frame_duration_hit
		)
	)
	if wait_hurt_animation:
		sub_sequence.actions.push_back(parallel_winddown)
	return sub_sequence


func write_attack(
	state: teCombatState,
	action: teCombatActionUnitAttack,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase:
	var attacker := state.unit(action.unit_id)
	if not attacker:
		return null
	var unit_profile := get_unit_profile(attacker.definition_uid)
	var attack_kind := unit_profile.attack
	var combo_hit_idx = context.read_or(teCombatContext.COMBO_HIT, -1)
	var combo_length = context.read_or(teCombatContext.COMBO_LENGTH, 0)
	return teVisualActions.sub_sequence(
		write_attack_windup(action.unit_id, attack_kind, combo_hit_idx, combo_length),
		write_attack_post_windup(attacker, action.unit_id, action.target_id, attack_kind),
		teVisualActions.emit(events_buffer, state)
	)


func write_attack_windup(
	attacker_id: int,
	attack_kind: teVisualWriting.AttackKind,
	combo_hit_idx: int = -1,
	combo_length: int = 0
) -> teVisualActionBase:
	var attack_act := get_attack_act(attack_kind)
	var is_combo: bool = combo_hit_idx != -1
	if not is_combo:
		return teVisualActions.unit_windup(attacker_id, attack_act)
	return teVisualActions.unit_combo(
		attacker_id, attack_act,
		combo_hit_idx, combo_length
	)


func write_attack_post_windup(
	attacker: teCombatUnitState,
	attacker_id: int,
	target_id: int,
	attack_kind: teVisualWriting.AttackKind
) -> teVisualActionBase:
	match attack_kind:
		teVisualWriting.AttackKind.MELEE:
			return null
		teVisualWriting.AttackKind.PROJECTILE:
			return teVisualActions.unit_shoot_projectile(
				attacker_id,
				target_id,
				attacker.definition_uid
			)
		teVisualWriting.AttackKind.CAST:
			return teVisualActions.vfx_on_target(
				attacker.definition_uid,
				target_id,
			)
	return null


func get_attack_act(attack_kind: teVisualWriting.AttackKind) -> StringName:
	match attack_kind:
		teVisualWriting.AttackKind.MELEE:
			return teVisualActs.MELEE
		teVisualWriting.AttackKind.PROJECTILE:
			return teVisualActs.RANGED
		teVisualWriting.AttackKind.CAST:
			return teVisualActs.CAST
	return ""
