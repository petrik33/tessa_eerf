class_name CombatUiOutlines extends Node2D

@export var combat_observer: CombatObserver

@onready var unit_outline: HexGridRendererBase = %CurrentUnit
@onready var move_range_outline: HexGridRendererBase = %MoveRange
@onready var mouse_pick_outline: HexGridRendererBase = %MouseHover
@onready var enemies_outline: HexGridRendererBase = %Enemies
@onready var allies_outline: HexGridRendererBase = %Allies
@onready var move_path_outline: HexGridRendererBase = %MovePath


func _on_hex_picking_updated(previous_hex: Vector2i, new_hex: Vector2i) -> void:
	mouse_pick_outline.grid = HexGrids.point(new_hex)


func _on_potential_command_changed(command: CombatCommandBase) -> void:
	if command == null:
		mouse_pick_outline.hide()
		move_path_outline.hide()
		return
	
	mouse_pick_outline.show()
	move_path_outline.show()

	if command is CombatCommandAttackUnit:
		move_path_outline.grid = HexGrids.points(
			combat_observer.runtime().navigation().path(command.move_id_path)
		)
		move_path_outline.show()
	elif command is CombatCommandMoveUnit:
		move_path_outline.grid = HexGrids.points(
			combat_observer.runtime().navigation().path(command.id_path)
		)


func _on_turn_started(side_idx: int) -> void:
	var current_unit = combat_observer.runtime().state().current_unit()
	unit_outline.grid = HexGrids.point(
		current_unit.placement
	)
	move_range_outline.grid = HexGrids.ranged(
		current_unit.placement,
		current_unit.stats().speed,
		combat_observer.runtime().navigation().grid()
	)
	enemies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, combat_observer.runtime().state().enemies(side_idx).map(
			func(unit: CombatUnit): return unit.placement
		))
	)
	allies_outline.grid = HexGrids.points(
		Utils.to_typed(TYPE_VECTOR2I, combat_observer.runtime().state().allies(side_idx)
			.filter(
				func(unit: CombatUnit): return unit != current_unit
			)
			.map(
				func(unit: CombatUnit): return unit.placement
			)
		)
	)


func _on_turn_finished(side_idx: int) -> void:
	move_path_outline.grid = null
	mouse_pick_outline.grid = null
