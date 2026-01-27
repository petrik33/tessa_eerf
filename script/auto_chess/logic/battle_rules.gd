class_name acBattleRules extends Resource


func apply(state: acBattleState, delta: float) -> void:
	process_units(state, delta) 


func process_units(state: acBattleState, delta: float) -> void:
	for uid in state.units:
		var unit := state.units[uid]
		if not unit.alive:
			continue
		if unit.is_stunned():
			continue
		if unit.is_casting():
			continue
		var target := acTargeting.find(unit, state)
		if try_cast_ability(state, unit, target):
			continue
		if try_attack(state, unit, target):
			continue
		try_move(state, unit, target, delta)


func try_cast_ability(state: acBattleState, unit: acUnitState, target: acUnitState) -> bool:
	return false


func try_attack(state: acBattleState, unit: acUnitState, target: acUnitState) -> bool:
	var dist_to_target := HexMath.distance(unit.hex, target.hex)
	return dist_to_target <= unit.definition.attack_range


func try_move(state: acBattleState, unit: acUnitState, target: acUnitState, delta: float) -> bool:
	if target == null:
		return false
	if HexMath.distance(unit.hex, target.hex) <= unit.definition.attack_range:
		return false
	if unit.moving:
		update_movement(state, unit, delta)
		return true
	var next_hex := acMovement.pick_next_hex(unit, target, state)
	if next_hex == unit.hex:
		return false
	begin_move(state, unit, next_hex)
	return true


func update_movement(state: acBattleState, unit: acUnitState, delta: float):
	unit.movement_progress += delta * unit.move_speed 
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
	state.board.units.erase(unit.hex)
	unit.hex = unit.movement_target_hex
	state.board.units.set(unit.hex, unit)
	unit.moving = false
