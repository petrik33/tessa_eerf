class_name CombatUiOutlines extends Node2D

@onready var unit_outline: HexGridRendererBase = %CurrentUnit
@onready var move_range_outline: HexGridRendererBase = %MoveRange
@onready var mouse_pick_outline: HexGridRendererBase = %MouseHover
@onready var enemies_outline: HexGridRendererBase = %Enemies
@onready var allies_outline: HexGridRendererBase = %Allies
@onready var move_path_outline: HexGridRendererBase = %MovePath


func update_turn_context(turn_context: CombatTurnContext) -> void:
	var current_unit = turn_context.observed_state.current_unit()
	unit_outline.grid = HexGrids.point(
		current_unit.placement
	)
	move_range_outline.grid = HexGrids.ranged(
		current_unit.placement,
		current_unit.movement_range(),
		turn_context.services.navigation.grid
	)
	enemies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, turn_context.observed_state.enemy_units(turn_context.observed_state.current_army_handle()).map(
			func(unit: CombatUnit): return unit.placement
		))
	)
	allies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, turn_context.observed_state.ally_units(turn_context.observed_state.current_army_handle())
			.filter(
				func(unit: CombatUnit): return unit != current_unit
			)
			.map(
				func(unit: CombatUnit): return unit.placement
			)
		)
	)


func update_potential_command(turn_context: CombatTurnContext, command: CombatCommandBase) -> void:
	if command == null:
		mouse_pick_outline.hide()
		move_path_outline.hide()
		return

	mouse_pick_outline.show()
	move_path_outline.show()

	if command is CombatCommandAttackUnit:
		move_path_outline.grid = HexGrids.points(
			turn_context.services.navigation.path(command.move_id_path)
		)
		mouse_pick_outline.grid = HexGrids.point(command.attacked_hex)
	elif command is CombatCommandMoveUnit:
		move_path_outline.grid = HexGrids.points(
			turn_context.services.navigation.path(command.id_path)
		)
		mouse_pick_outline.grid = HexGrids.point(turn_context.services.navigation.hex(command.id_path[-1]))
