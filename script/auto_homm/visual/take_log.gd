class_name teVisualTakeLog extends teVisualTakeLogBase


@export var combat: teCombat


var unit_names: Dictionary[int, StringName] = {}


func initialize(state: teCombatState):
	for unit_id in state.all_units_id():
		var unit := state.unit(unit_id)
		unit_names[unit_id] = unit.definition_uid


func describe(action: teVisualActionBase) -> String:
	if action is teVisualActionUnitAct:
		return "%s act=%s" % [
			_unit_name(action.unit_id),
			action.act
		]

	if action is teVisualActionUnitWindup:
		return "%s windup=%s" % [
			_unit_name(action.unit_id),
			action.act
		]

	if action is teVisualActionUnitCombo:
		return "%s combo %d/%d act=%s" % [
			_unit_name(action.unit_id),
			action.idx + 1,
			action.total,
			action.base_act
		]

	if action is teVisualActionUnitWaitWinddown:
		return "%s wait winddown" % [
			_unit_name(action.unit_id)
		]

	if action is teVisualActionUnitMove:
		var start_hex = action.path.front() if not action.path.is_empty() else Vector2i.ZERO
		var end_hex = action.path.back() if not action.path.is_empty() else Vector2i.ZERO

		return "%s move %s -> %s (%d hexes)" % [
			_unit_name(action.unit_id),
			start_hex,
			end_hex,
			action.path.size()
		]

	if action is teVisualActionUnitFlash:
		return "%s flash %.2fs wait=%s" % [
			_unit_name(action.unit_id),
			action.time,
			action.wait
		]

	if action is teVisualActionUnitShootProjectile:
		return "%s shoot %s projectile=%s" % [
			_unit_name(action.shooter_id),
			_unit_name(action.target_id),
			action.projectile_uid
		]

	if action is teVisualActionShootProjectile:
		return "Projectile %s %s -> %s" % [
			action.projectile_uid,
			action.origin,
			action.target
		]

	if action is teVisualActionUnitGoIdle:
		return "%s go idle" % [
			_unit_name(action.unit_id)
		]

	if action is teVisualActionVfxOnTarget:
		return "VFX %s target=%s socket=%s" % [
			action.vfx_uid,
			_unit_name(action.target_unit_id),
			action.socket
		]

	if action is teVisualActionFreezeFrame:
		return "Freeze frame %.2fs" % [
			action.duration
		]

	if action is teVisualActionWait:
		return "Wait %.2fs" % [
			action.time_sec
		]

	if action is teVisualActionEmitCombatEvents:
		var names: PackedStringArray = []

		for event in action.events:
			names.push_back(_event_name(event))

		return "Events [%s]" % ", ".join(names)

	return _fallback_description(action)


func _unit_name(unit_id: int) -> String:
	return "%s#%d" % [
		unit_names.get(unit_id, "Unknown"),
		unit_id
	]


func _fallback_description(action: teVisualActionBase) -> String:
	return _script_name(action)


func _event_name(event: teCombatEventBase) -> String:
	return _script_name(event)


func _script_name(obj: Object) -> String:
	var script = obj.get_script()

	if script != null:
		var path: String = script.resource_path

		if not path.is_empty():
			return path.get_file().get_basename()

	return str(obj)
