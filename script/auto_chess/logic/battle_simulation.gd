class_name acBattleSimulation extends Resource


func process_units(state: acBattleState, delta: float) -> void:
	for uid in state.units:
		var unit := state.units[uid]
		if not unit.alive:
			continue
		if unit.is_stunned():
			continue
		if unit.is_casting():
			continue
		if unit.try_cast_ability():
			continue
		if unit.try_attack():
			continue
		unit.try_move(delta)


func try_cast_ability() -> bool:
	return false


func try_attack() -> bool:
	return false


func try_move(state: acBattleState, unit: acUnitState, delta: float) -> bool:
	var target := acTargeting.find(unit, state)
	if target == null:
		return false
	if HexMath.distance(unit.hex, target.hex) <= unit.definition.attack_range:
		return false
	if unit.moving:
		return update_movement(state, unit, delta)
	var next_hex := acMovement.pick_next_hex(unit, target, state)
	if next_hex == unit.hex:
		return false
	begin_move(state, unit, next_hex)
	return true


func update_movement(state: acBattleState, unit: acUnitState, delta: float):
	unit.movement_progress += delta / unit.move_duration
	if unit.movement_progress < 1.0:
		return
	finish_move(state, unit)


func begin_move(state: acBattleState, unit: acUnitState, target_hex: Vector2i):
	unit.moving = true
	unit.movement_target_hex = target_hex
	unit.movement_progress = 0.0
	state.board.reserve_hex(target_hex, unit)


func finish_move(state: acBattleState, unit: acUnitState):
	state.board.release_hex(unit.hex)
	unit.hex = unit.movement_target_hex
	unit.moving = false
