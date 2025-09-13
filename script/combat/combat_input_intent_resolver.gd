class_name CombatInputIntentResolver extends Resource


func get_potential_command(
	context: CombatTurnContext,
	previous_hex: Vector2i,
	target_hex: Vector2i
) -> CombatCommandBase:
	if not context.services.navigation.grid.has_point(target_hex):
		return null

	var target_distance = HexMath.distance(
		context.observed_state.current_unit().placement,
		target_hex
	)

	if target_distance > context.observed_state.current_unit().stats().speed:
		return null

	var target_unit_handle = context.observed_state.find_unit_handle_by_hex(target_hex)

	if target_unit_handle == null:
		return CombatCommands.move_unit(
			context.services.pathfinding.id_path(
				context.observed_state.current_unit().placement, target_hex
			)
		)
	else:
		var target_unit := context.observed_state.unit(target_unit_handle)
		if target_unit.is_an_ally(context.observed_state.current_army_handle()):
			return null
		
		# TODO: Think of better algorithm to find hex to attack from
		var attack_hex := previous_hex
			
		if not HexMath.are_neighbors(attack_hex, target_hex):
			return null

		var move_path = context.services.pathfinding.id_path(
			context.observed_state.current_unit().placement,
			attack_hex
		)
		
		if move_path.is_empty() or move_path.size() - 1 > context.observed_state.current_unit().stats().speed:
			return null

		return CombatCommands.attack_unit(
			move_path, target_hex
		)
