class_name CombatPlayerIntentResolver extends Resource


func get_potential_command(player: CombatPlayer, _previous_hex: Vector2i, target_hex: Vector2i) -> CombatCommandBase:
	if not player.get_runtime().navigation().grid().has_point(target_hex):
		return null

	var target_distance = HexMath.distance(
		player.get_observed_state().current_placement(),
		target_hex
	)

	if target_distance > player.get_observed_state().current_unit().stats().speed:
		return null

	var targeted_unit = player.get_observed_state().unit_on_hex(target_hex)

	if targeted_unit == null:
		return CombatCommands.move_unit(
			player.get_runtime().pathfinding().id_path(
				player.get_observed_state().current_unit().placement, target_hex
			)
		)
	elif targeted_unit.is_an_enemy(player.get_army_handle()):
		# TODO: Actual algorithm to find hex to attack from
		var move_path = player.get_runtime().pathfinding().id_path(
			player.get_observed_state().current_unit().placement,
			target_hex
		)
		move_path.remove_at(move_path.size() - 1)
		return CombatCommands.attack_unit(
			move_path, target_hex
		)

	return null
