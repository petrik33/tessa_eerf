class_name CombatVisualization extends Node

@export var combat: Combat
@export var config: CombatConfig
@export var units_node: Node
@export var hex_layout: HexLayout

var _unit_visuals: Array[UnitCombatVisualsBase] = []
	
func _handle_command_processed(command: CombatCommandBase, buffer: CombatActionsBuffer):
	for action in buffer.actions:
		_handle_action(action)

func _handle_action(action: CombatActionBase):
	if action is CombatActionMove:
		var unit = _unit_visuals[action.unit_idx]
		var path = Utils.to_typed(TYPE_VECTOR2, action.path.map(
			func(hex: Vector2i): return hex_layout.hex_to_pixel(hex)
		))
		unit.walk_along(path)

func _handle_combat_started():
	for unit in combat.context().state().units:
		var visuals = unit.data.combat_visuals.instantiate() as UnitCombatVisualsBase
		_unit_visuals.append(visuals)
		visuals.position = hex_layout.hex_to_pixel(unit.placement)
		visuals.face_direction(0 if unit.side_idx == 0 else PI)
		visuals.go_to_idle()
		units_node.add_child(visuals)
	return

func _handle_combat_finished():
	for unit in _unit_visuals:
		unit.queue_free()
	_unit_visuals.clear()
